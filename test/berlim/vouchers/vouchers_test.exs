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

  test "list_vouchers/0 returns all vouchers" do
    voucher = insert(:voucher)
    vouchers = Vouchers.list_vouchers()

    assert List.first(vouchers).id == voucher.id
    assert Enum.count(vouchers) == 1
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

    test "list_taxi_vouchers/2 with payed_start_at filter,
          returns all vouchers that belongs to the taxi that were paid during or after a date" do
      taxi = insert(:taxi)

      insert(:voucher, %{taxi: taxi, payed_at: start_date()})
      insert(:voucher, %{taxi: taxi, payed_at: pre_start_date()})

      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi, [{"payed_start_at", start_date()}])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      assert Enum.all?(taxi_vouchers, fn v ->
               v.taxi_id == taxi.id and v.payed_at >= start_date()
             end)
    end

    test "list_taxi_vouchers/2 with payed_end_at filter,
          returns all vouchers that belongs to the taxi that were paid before or during a date" do
      taxi = insert(:taxi)

      insert(:voucher, %{taxi: taxi, payed_at: end_date()})
      insert(:voucher, %{taxi: taxi, payed_at: post_end_date()})

      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi, [{"payed_end_at", end_date()}])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      assert Enum.all?(taxi_vouchers, fn v ->
               v.taxi_id == taxi.id and v.payed_at <= end_date()
             end)
    end

    test "list_taxi_vouchers/2 with payed_start_at and payed_end_at filters,
          returns all vouchers that belongs to the taxi that were paid between a date interval" do
      taxi = insert(:taxi)

      insert(:voucher, %{taxi: taxi, payed_at: between_start_and_end_dates()})
      insert(:voucher, %{taxi: taxi, payed_at: pre_start_date()})
      insert(:voucher, %{taxi: taxi, payed_at: post_end_date()})

      taxi_vouchers =
        Vouchers.list_taxi_vouchers(taxi, [
          {"payed_start_at", start_date()},
          {"payed_end_at", end_date()}
        ])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      assert Enum.all?(taxi_vouchers, fn v ->
               v.taxi_id == taxi.id and
                 Timex.between?(v.payed_at, start_date(), end_date())
             end)
    end

    test "list_taxi_vouchers/2 with created_start_at filter,
          returns all vouchers that belongs to the taxi that were created during or after a date" do
      taxi = insert(:taxi)

      insert(:voucher, %{taxi: taxi, inserted_at: start_date()})
      insert(:voucher, %{taxi: taxi, inserted_at: pre_start_date()})

      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi, [{"created_start_at", start_date()}])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      assert Enum.all?(taxi_vouchers, fn v ->
               v.taxi_id == taxi.id and v.inserted_at >= start_date()
             end)
    end

    test "list_taxi_vouchers/2 with created_end_at filter,
          returns all vouchers that belongs to the taxi that were created before or during a date" do
      taxi = insert(:taxi)

      insert(:voucher, %{taxi: taxi, inserted_at: end_date()})
      insert(:voucher, %{taxi: taxi, inserted_at: post_end_date()})

      taxi_vouchers = Vouchers.list_taxi_vouchers(taxi, [{"created_end_at", end_date()}])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      assert Enum.all?(taxi_vouchers, fn v ->
               v.taxi_id == taxi.id and v.inserted_at <= end_date()
             end)
    end

    test "list_taxi_vouchers/2 with created_start_at and created_end_at filters,
          returns all vouchers that belongs to the taxi that were created between date interval" do
      taxi = insert(:taxi)

      insert(:voucher, %{taxi: taxi, inserted_at: between_start_and_end_dates()})
      insert(:voucher, %{taxi: taxi, inserted_at: pre_start_date()})
      insert(:voucher, %{taxi: taxi, inserted_at: post_end_date()})

      taxi_vouchers =
        Vouchers.list_taxi_vouchers(taxi, [
          {"created_start_at", start_date()},
          {"created_end_at", end_date()}
        ])

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      assert Enum.all?(taxi_vouchers, fn v ->
               v.taxi_id == taxi.id and
                 Timex.between?(v.inserted_at, start_date(), end_date())
             end)
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

    test "list_company_vouchers/2 with payed_start_at filter,
          returns all vouchers that belongs to the company that were paid during or after a date",
         %{company: company, employee: company_employee} do
      insert(:voucher, %{employee: company_employee, payed_at: start_date()})
      insert(:voucher, %{employee: company_employee, payed_at: pre_start_date()})

      company_vouchers =
        Vouchers.list_company_vouchers(company, [{"payed_start_at", start_date()}])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      assert Enum.all?(company_vouchers, fn v ->
               v.employee.company_id == company.id and v.payed_at >= start_date()
             end)
    end

    test "list_company_vouchers/2 with payed_end_at filter,
          returns all vouchers that belongs to the company that were paid before or during a date",
         %{company: company, employee: company_employee} do
      insert(:voucher, %{employee: company_employee, payed_at: end_date()})
      insert(:voucher, %{employee: company_employee, payed_at: post_end_date()})

      company_vouchers = Vouchers.list_company_vouchers(company, [{"payed_end_at", end_date()}])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      assert Enum.all?(company_vouchers, fn v ->
               v.employee.company_id == company.id and v.payed_at <= end_date()
             end)
    end

    test "list_company_vouchers/2 with payed_start_at and payed_end_at filters,
          returns all vouchers that belongs to the company that were paid between a date interval",
         %{company: company, employee: company_employee} do
      insert(:voucher, %{employee: company_employee, payed_at: between_start_and_end_dates()})
      insert(:voucher, %{employee: company_employee, payed_at: pre_start_date()})
      insert(:voucher, %{employee: company_employee, payed_at: post_end_date()})

      company_vouchers =
        Vouchers.list_company_vouchers(company, [
          {"payed_start_at", start_date()},
          {"payed_end_at", end_date()}
        ])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      assert Enum.all?(company_vouchers, fn v ->
               v.employee.company_id == company.id and
                 Timex.between?(v.payed_at, start_date(), end_date())
             end)
    end

    test "list_company_vouchers/2 with created_start_at filter,
          returns all vouchers that belongs to the company that were created during or after a date",
         %{company: company, employee: company_employee} do
      insert(:voucher, %{employee: company_employee, inserted_at: start_date()})
      insert(:voucher, %{employee: company_employee, inserted_at: pre_start_date()})

      company_vouchers =
        Vouchers.list_company_vouchers(company, [{"created_start_at", start_date()}])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      assert Enum.all?(company_vouchers, fn v ->
               v.employee.company_id == company.id and v.inserted_at >= start_date()
             end)
    end

    test "list_company_vouchers/2 with created_end_at filter,
          returns all vouchers that belongs to the company that were created before or during a date",
         %{company: company, employee: company_employee} do
      insert(:voucher, %{employee: company_employee, inserted_at: end_date()})
      insert(:voucher, %{employee: company_employee, inserted_at: post_end_date()})

      company_vouchers = Vouchers.list_company_vouchers(company, [{"created_end_at", end_date()}])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      assert Enum.all?(company_vouchers, fn v ->
               v.employee.company_id == company.id and v.inserted_at <= end_date()
             end)
    end

    test "list_company_vouchers/2 with created_start_at and created_end_at filters,
          returns all vouchers that belongs to the company that were created between a date interval",
         %{company: company, employee: company_employee} do
      insert(:voucher, %{employee: company_employee, inserted_at: between_start_and_end_dates()})
      insert(:voucher, %{employee: company_employee, inserted_at: pre_start_date()})
      insert(:voucher, %{employee: company_employee, inserted_at: post_end_date()})

      company_vouchers =
        Vouchers.list_company_vouchers(company, [
          {"created_start_at", start_date()},
          {"created_end_at", end_date()}
        ])

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      assert Enum.all?(company_vouchers, fn v ->
               v.employee.company_id == company.id and
                 Timex.between?(v.inserted_at, start_date(), end_date())
             end)
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

  defp start_date do
    Timex.to_datetime({{2019, 6, 8}, {0, 0, 0}})
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
