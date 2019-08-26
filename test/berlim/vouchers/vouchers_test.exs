defmodule Berlim.VouchersTest do
  use Berlim.DataCase, async: true
  use Timex

  import Berlim.Factory
  import Swoosh.TestAssertions

  alias Berlim.{EmailGenerator, Vouchers}

  @invalid_attrs %{value: nil}

  defp voucher_params do
    params_with_assocs(:voucher)
  end

  describe "list_vouchers" do
    test "list_vouchers/0 returns all vouchers" do
      voucher = create_voucher()
      vouchers = Vouchers.list_vouchers()

      assert List.first(vouchers).id == voucher.id
      assert Enum.count(vouchers) == 1
    end

    test "list_vouchers/1 with paid_start_at filter,
          returns all vouchers that were paid during or after a date" do
      create_voucher(%{paid_at: start_date()})
      create_voucher(%{paid_at: pre_start_date()})

      vouchers = Vouchers.list_vouchers([{"paid_start_at", start_date()}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert voucher.paid_at >= start_date()
    end

    test "list_vouchers/1 with paid_end_at filter,
          returns all vouchers that were paid before or during a date" do
      create_voucher(%{paid_at: end_date()})
      create_voucher(%{paid_at: post_end_date()})

      vouchers = Vouchers.list_vouchers([{"paid_end_at", end_date()}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert voucher.paid_at <= end_date()
    end

    test "list_vouchers/1 with paid_start_at and paid_end_at filters,
          returns all vouchers that were paid between a date interval" do
      create_voucher(%{paid_at: between_start_and_end_dates()})
      create_voucher(%{paid_at: pre_start_date()})
      create_voucher(%{paid_at: post_end_date()})

      vouchers =
        Vouchers.list_vouchers([
          {"paid_start_at", start_date()},
          {"paid_end_at", end_date()}
        ])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert Timex.between?(voucher.paid_at, start_date(), end_date())
    end

    test "list_vouchers/1 with created_start_at filter,
          returns all vouchers that were created during or after a date" do
      create_voucher(%{inserted_at: start_date()})
      create_voucher(%{inserted_at: pre_start_date()})

      vouchers = Vouchers.list_vouchers([{"created_start_at", start_date()}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert voucher.inserted_at >= start_date()
    end

    test "list_vouchers/1 with created_end_at filter,
          returns all vouchers that were created before or during a date" do
      create_voucher(%{inserted_at: end_date()})
      create_voucher(%{inserted_at: post_end_date()})

      vouchers = Vouchers.list_vouchers([{"created_end_at", end_date()}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert voucher.inserted_at <= end_date()
    end

    test "list_vouchers/1 with created_start_at and created_end_at filters,
          returns all vouchers that were created between date interval" do
      create_voucher(%{inserted_at: between_start_and_end_dates()})
      create_voucher(%{inserted_at: pre_start_date()})
      create_voucher(%{inserted_at: post_end_date()})

      vouchers =
        Vouchers.list_vouchers([
          {"created_start_at", start_date()},
          {"created_end_at", end_date()}
        ])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert Timex.between?(voucher.inserted_at, start_date(), end_date())
    end

    test "list_vouchers/1 with taxi_id filter, returns all vouchers that belongs to a taxi" do
      taxi = insert(:taxi)
      create_voucher(%{taxi: taxi})
      create_voucher()

      vouchers = Vouchers.list_vouchers([{"taxi_id", taxi.id}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)
      assert voucher.taxi_id == taxi.id
    end

    test "list_vouchers/1 with employee_id filter, returns all vouchers that belongs to an employee" do
      employee = insert(:employee)
      create_voucher(%{employee: employee})
      create_voucher()

      vouchers = Vouchers.list_vouchers([{"employee_id", employee.id}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)
      assert voucher.employee_id == employee.id
    end

    test "list_vouchers/1 with company_id filter, returns all vouchers that belongs to a company" do
      company = insert(:company)
      employee = insert(:employee, %{company: company})
      create_voucher(%{employee: employee})
      create_voucher()

      vouchers = Vouchers.list_vouchers([{"company_id", company.id}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)
      assert voucher.employee.company_id == company.id
    end

    test "list_vouchers/1 with voucher_id filter, returns a voucher" do
      voucher = create_voucher()

      voucher_returned = Vouchers.list_vouchers([{"voucher_id", voucher.id}])

      assert is_list(voucher_returned)
      assert Enum.count(voucher_returned) == 1

      voucher_returned = List.first(voucher_returned)
      assert voucher_returned.id == voucher.id
    end

    test "list_vouchers/1 with paid filter and its value equals true, returns all vouchers that were paid" do
      create_voucher()
      _not_paid_voucher = create_voucher(%{paid_at: nil})

      vouchers = Vouchers.list_vouchers([{"paid", true}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)
      refute is_nil(voucher.paid_at)
    end

    test "list_vouchers/1 with paid filter and its value equals false, returns all vouchers that not were paid" do
      create_voucher()
      _not_paid_voucher = create_voucher(%{paid_at: nil})

      vouchers = Vouchers.list_vouchers([{"paid", false}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)
      assert is_nil(voucher.paid_at)
    end
  end

  describe "list_taxi_vouchers" do
    test "list_taxi_vouchers/1 returns all vouchers that belongs to the taxi" do
      taxi = insert(:taxi)
      insert_list(5, :voucher, %{taxi: taxi})
      insert_list(3, :voucher)
      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi)

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 5
      assert Enum.all?(taxi_vouchers, fn v -> v.taxi_id == taxi.id end)
    end

    test "list_taxi_vouchers/2 with paid_start_at filter,
          returns all vouchers that belongs to the taxi that were paid during or after a date" do
      taxi = insert(:taxi)

      create_voucher(%{taxi: taxi, paid_at: start_date()})
      create_voucher(%{taxi: taxi, paid_at: pre_start_date()})

      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi, [{"paid_start_at", start_date()}])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher.taxi_id == taxi.id
      assert voucher.paid_at >= start_date()
    end

    test "list_taxi_vouchers/2 with paid_end_at filter,
          returns all vouchers that belongs to the taxi that were paid before or during a date" do
      taxi = insert(:taxi)

      create_voucher(%{taxi: taxi, paid_at: end_date()})
      create_voucher(%{taxi: taxi, paid_at: post_end_date()})

      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi, [{"paid_end_at", end_date()}])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher.taxi_id == taxi.id
      assert voucher.paid_at <= end_date()
    end

    test "list_taxi_vouchers/2 with paid_start_at and paid_end_at filters,
          returns all vouchers that belongs to the taxi that were paid between a date interval" do
      taxi = insert(:taxi)

      create_voucher(%{taxi: taxi, paid_at: between_start_and_end_dates()})
      create_voucher(%{taxi: taxi, paid_at: pre_start_date()})
      create_voucher(%{taxi: taxi, paid_at: post_end_date()})

      taxi_vouchers =
        Vouchers.list_taxi_vouchers(taxi, [
          {"paid_start_at", start_date()},
          {"paid_end_at", end_date()}
        ])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher.taxi_id == taxi.id
      assert Timex.between?(voucher.paid_at, start_date(), end_date())
    end

    test "list_taxi_vouchers/2 with created_start_at filter,
          returns all vouchers that belongs to the taxi that were created during or after a date" do
      taxi = insert(:taxi)

      create_voucher(%{taxi: taxi, inserted_at: start_date()})
      create_voucher(%{taxi: taxi, inserted_at: pre_start_date()})

      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi, [{"created_start_at", start_date()}])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher.taxi_id == taxi.id
      assert voucher.inserted_at >= start_date()
    end

    test "list_taxi_vouchers/2 with created_end_at filter,
          returns all vouchers that belongs to the taxi that were created before or during a date" do
      taxi = insert(:taxi)

      create_voucher(%{taxi: taxi, inserted_at: end_date()})
      create_voucher(%{taxi: taxi, inserted_at: post_end_date()})

      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi, [{"created_end_at", end_date()}])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher.taxi_id == taxi.id
      assert voucher.inserted_at <= end_date()
    end

    test "list_taxi_vouchers/2 with created_start_at and created_end_at filters,
          returns all vouchers that belongs to the taxi that were created between date interval" do
      taxi = insert(:taxi)

      create_voucher(%{taxi: taxi, inserted_at: between_start_and_end_dates()})
      create_voucher(%{taxi: taxi, inserted_at: pre_start_date()})
      create_voucher(%{taxi: taxi, inserted_at: post_end_date()})

      taxi_vouchers =
        Vouchers.list_taxi_vouchers(taxi, [
          {"created_start_at", start_date()},
          {"created_end_at", end_date()}
        ])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher.taxi_id == taxi.id
      assert Timex.between?(voucher.inserted_at, start_date(), end_date())
    end

    test "list_taxi_vouchers/2 with paid filter and its value equals true,
          returns all vouchers that belongs to the taxi that were paid" do
      taxi = insert(:taxi)
      create_voucher(%{taxi: taxi})
      _not_paid_voucher = create_voucher(%{taxi: taxi, paid_at: nil})

      vouchers = Vouchers.list_taxi_vouchers(taxi, [{"paid", true}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert voucher.taxi_id == taxi.id
      refute is_nil(voucher.paid_at)
    end

    test "list_taxi_vouchers/2 with paid filter and its value equals false,
          returns all vouchers that belongs to the taxi that not were paid" do
      taxi = insert(:taxi)
      create_voucher(%{taxi: taxi})
      _not_paid_voucher = create_voucher(%{taxi: taxi, paid_at: nil})

      vouchers = Vouchers.list_taxi_vouchers(taxi, [{"paid", false}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert voucher.taxi_id == taxi.id
      assert is_nil(voucher.paid_at)
    end
  end

  describe "list_company_vouchers" do
    setup [:create_company, :create_employee]

    test "list_company_vouchers/1 returns all vouchers that belongs to the company", %{
      company: company,
      employee: company_employee
    } do
      insert_list(5, :voucher, %{employee: company_employee})
      insert_list(3, :voucher)

      company_vouchers = Vouchers.list_company_vouchers(company)

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 5
      assert Enum.all?(company_vouchers, fn v -> v.employee.company_id == company.id end)
    end

    test "list_company_vouchers/2 with paid_start_at filter,
          returns all vouchers that belongs to the company that were paid during or after a date",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, paid_at: start_date()})
      create_voucher(%{employee: company_employee, paid_at: pre_start_date()})

      company_vouchers =
        Vouchers.list_company_vouchers(company, [{"paid_start_at", start_date()}])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher.employee.company_id == company.id
      assert voucher.paid_at >= start_date()
    end

    test "list_company_vouchers/2 with paid_end_at filter,
          returns all vouchers that belongs to the company that were paid before or during a date",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, paid_at: end_date()})
      create_voucher(%{employee: company_employee, paid_at: post_end_date()})

      company_vouchers = Vouchers.list_company_vouchers(company, [{"paid_end_at", end_date()}])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher.employee.company_id == company.id
      assert voucher.paid_at <= end_date()
    end

    test "list_company_vouchers/2 with paid_start_at and paid_end_at filters,
          returns all vouchers that belongs to the company that were paid between a date interval",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, paid_at: between_start_and_end_dates()})
      create_voucher(%{employee: company_employee, paid_at: pre_start_date()})
      create_voucher(%{employee: company_employee, paid_at: post_end_date()})

      company_vouchers =
        Vouchers.list_company_vouchers(company, [
          {"paid_start_at", start_date()},
          {"paid_end_at", end_date()}
        ])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher.employee.company_id == company.id
      assert Timex.between?(voucher.paid_at, start_date(), end_date())
    end

    test "list_company_vouchers/2 with created_start_at filter,
          returns all vouchers that belongs to the company that were created during or after a date",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, inserted_at: start_date()})
      create_voucher(%{employee: company_employee, inserted_at: pre_start_date()})

      company_vouchers =
        Vouchers.list_company_vouchers(company, [{"created_start_at", start_date()}])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher.employee.company_id == company.id
      assert voucher.inserted_at >= start_date()
    end

    test "list_company_vouchers/2 with created_end_at filter,
          returns all vouchers that belongs to the company that were created before or during a date",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, inserted_at: end_date()})
      create_voucher(%{employee: company_employee, inserted_at: post_end_date()})

      company_vouchers = Vouchers.list_company_vouchers(company, [{"created_end_at", end_date()}])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher.employee.company_id == company.id
      assert voucher.inserted_at <= end_date()
    end

    test "list_company_vouchers/2 with created_start_at and created_end_at filters,
          returns all vouchers that belongs to the company that were created between a date interval",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, inserted_at: between_start_and_end_dates()})
      create_voucher(%{employee: company_employee, inserted_at: pre_start_date()})
      create_voucher(%{employee: company_employee, inserted_at: post_end_date()})

      company_vouchers =
        Vouchers.list_company_vouchers(company, [
          {"created_start_at", start_date()},
          {"created_end_at", end_date()}
        ])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher.employee.company_id == company.id
      assert Timex.between?(voucher.inserted_at, start_date(), end_date())
    end

    test "list_company_vouchers/2 with employee_id filter,
          returns all vouchers that belongs to an employee of the company",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee})
      create_voucher()

      company_employee_vouchers =
        Vouchers.list_company_vouchers(company, [{"employee_id", company_employee.id}])

      assert is_list(company_employee_vouchers)
      assert Enum.count(company_employee_vouchers) == 1

      voucher = List.first(company_employee_vouchers)

      assert voucher.employee_id == company_employee.id
    end

    test "list_company_vouchers/2 with matricula filter,
          returns all vouchers that belongs to an employee of the company",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee})
      create_voucher()

      company_employee_vouchers =
        Vouchers.list_company_vouchers(company, [{"matricula", company_employee.internal_id}])

      assert is_list(company_employee_vouchers)
      assert Enum.count(company_employee_vouchers) == 1

      voucher = List.first(company_employee_vouchers)

      assert voucher.employee.internal_id == company_employee.internal_id
    end

    test "list_company_vouchers/2 with sector_id filter,
          returns all vouchers that belongs to an sector of the company",
         %{company: company, employee: company_employee} do
      company_sector = insert(:sector, %{company: company})

      company_employee_of_another_sector =
        insert(:employee, %{company: company, sector: company_sector})

      create_voucher(%{employee: company_employee})
      create_voucher(%{employee: company_employee_of_another_sector})
      create_voucher()

      company_sector_vouchers =
        Vouchers.list_company_vouchers(company, [{"sector_id", company_sector.id}])

      assert is_list(company_sector_vouchers)
      assert Enum.count(company_sector_vouchers) == 1

      voucher = List.first(company_sector_vouchers)

      assert voucher.employee.sector_id == company_sector.id
    end

    test "list_company_vouchers/2 with paid filter and its value equals true,
          returns all vouchers that belongs to the company that were paid",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee})
      _not_paid_voucher = create_voucher(%{employee: company_employee, paid_at: nil})

      vouchers = Vouchers.list_company_vouchers(company, [{"paid", true}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert voucher.employee.company_id == company.id
      refute is_nil(voucher.paid_at)
    end

    test "list_company_vouchers/2 with paid filter and its value equals false,
          returns all vouchers that belongs to the company that not were paid",
         %{company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee})
      _not_paid_voucher = create_voucher(%{employee: company_employee, paid_at: nil})

      vouchers = Vouchers.list_company_vouchers(company, [{"paid", false}])

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher = List.first(vouchers)

      assert voucher.employee.company_id == company.id
      assert is_nil(voucher.paid_at)
    end
  end

  test "get_voucher!/1, returns the voucher with the given id" do
    voucher = insert(:voucher)

    assert Vouchers.get_voucher!(voucher.id).id == voucher.id
  end

  test "create_voucher/1 with valid data, creates a voucher" do
    assert {:ok, voucher} = Vouchers.create_voucher(voucher_params())
    assert_email_sent(EmailGenerator.voucher_receipt(voucher.taxi.email, voucher))
    assert_email_sent(EmailGenerator.voucher_receipt(voucher.employee.email, voucher))
    assert_email_sent(EmailGenerator.voucher_receipt(voucher.employee.company.email, voucher))
    assert voucher.to == "São Paulo"
  end

  test "create_voucher/2 with invalid data, returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Vouchers.create_voucher(@invalid_attrs)
  end

  test "pay_vouchers/2 updates all vouchers paid_at, updated_at and paid_by" do
    admin = insert(:admin)
    ids = insert_list(10, :voucher, value: 10) |> Enum.map(& &1.id)

    assert {:ok, total_paid} = Vouchers.pay_vouchers(ids, admin)

    vouchers = Vouchers.list_vouchers()

    assert total_paid == 100

    assert Enum.all?(vouchers, fn v ->
             v.paid_by_id == admin.id && not is_nil(v.paid_at) && v.updated_at == v.paid_at
           end)
  end

  test "change_voucher/0 returns a voucher changeset" do
    assert %Ecto.Changeset{} = Vouchers.change_voucher()
  end

  test "change_voucher/1 returns a voucher changeset" do
    voucher = insert(:voucher)
    assert %Ecto.Changeset{} = Vouchers.change_voucher(voucher)
  end

  test "change_voucher/2 returns a voucher changeset" do
    voucher = insert(:voucher)
    assert %Ecto.Changeset{} = Vouchers.change_voucher(voucher, %{value: 100})
  end

  defp create_company(_) do
    %{company: insert(:company)}
  end

  defp create_employee(%{company: company}) do
    %{employee: insert(:employee, %{company: company})}
  end

  defp create_voucher(attrs \\ %{}) do
    insert(:voucher, attrs)
  end

  defp start_date do
    Timex.to_datetime({{2019, 7, 3}, {0, 0, 0}})
  end

  defp pre_start_date do
    Timex.subtract(start_date(), Duration.from_days(1))
  end

  defp between_start_and_end_dates do
    Timex.add(start_date(), Duration.from_days(1))
  end

  defp end_date do
    Timex.add(between_start_and_end_dates(), Duration.from_days(1))
  end

  defp post_end_date do
    Timex.add(end_date(), Duration.from_days(1))
  end
end
