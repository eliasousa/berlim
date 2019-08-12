defmodule BerlimWeb.VoucherControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper
  use Timex

  import Berlim.Factory

  alias Berlim.Vouchers
  alias BerlimWeb.VoucherView

  @invalid_attrs %{value: nil}

  describe "GET /index, when user is admin" do
    setup [:authenticate_admin]

    test "list all vouchers", %{conn: conn} do
      insert_list(3, :voucher)

      conn = get(conn, Routes.voucher_path(conn, :index))

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 3
    end

    test "list all vouchers that were paid during or after a date", %{conn: conn} do
      create_voucher(%{payed_at: start_date()})
      create_voucher(%{payed_at: pre_start_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, payed_start_at: DateTime.to_string(start_date()))
        )

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher_payment_date = parse_date(List.first(vouchers)["payed_at"])

      assert voucher_payment_date >= start_date()
    end

    test "list all vouchers that were paid before or during a date", %{conn: conn} do
      create_voucher(%{payed_at: end_date()})
      create_voucher(%{payed_at: post_end_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, payed_end_at: DateTime.to_string(end_date()))
        )

      vouchers = json_response(conn, 200)["data"]
      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher_payment_date = parse_date(List.first(vouchers)["payed_at"])

      assert voucher_payment_date <= end_date()
    end

    test "list all vouchers that were paid between a date interval", %{conn: conn} do
      create_voucher(%{payed_at: between_start_and_end_dates()})
      create_voucher(%{payed_at: pre_start_date()})
      create_voucher(%{payed_at: post_end_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index,
            payed_start_at: DateTime.to_string(start_date()),
            payed_end_at: DateTime.to_string(end_date())
          )
        )

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher_payment_date = parse_date(List.first(vouchers)["payed_at"])

      assert Timex.between?(voucher_payment_date, start_date(), end_date())
    end

    test "list all vouchers that were created during or after a date", %{conn: conn} do
      create_voucher(%{inserted_at: start_date()})
      create_voucher(%{inserted_at: pre_start_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, created_start_at: DateTime.to_string(start_date()))
        )

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher_created_date = parse_date(List.first(vouchers)["inserted_at"])

      assert voucher_created_date >= start_date()
    end

    test "list all vouchers that were created before or during a date", %{conn: conn} do
      create_voucher(%{inserted_at: end_date()})
      create_voucher(%{inserted_at: post_end_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, created_end_at: DateTime.to_string(end_date()))
        )

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher_created_date = parse_date(List.first(vouchers)["inserted_at"])

      assert voucher_created_date <= end_date()
    end

    test "list all vouchers that were created between date interval", %{conn: conn} do
      create_voucher(%{inserted_at: between_start_and_end_dates()})
      create_voucher(%{inserted_at: pre_start_date()})
      create_voucher(%{inserted_at: post_end_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index,
            created_start_at: DateTime.to_string(start_date()),
            created_end_at: DateTime.to_string(end_date())
          )
        )

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      voucher_created_date = parse_date(List.first(vouchers)["inserted_at"])

      assert Timex.between?(voucher_created_date, start_date(), end_date())
    end

    test "list all vouchers that belongs to a taxi", %{conn: conn} do
      taxi = insert(:taxi)
      create_voucher(%{taxi: taxi})
      create_voucher()

      conn = get(conn, Routes.voucher_path(conn, :index, taxi_id: taxi.id))

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      assert List.first(vouchers)["taxi"]["id"] == taxi.id
    end

    test "list all vouchers that belongs to an employee", %{conn: conn} do
      employee = insert(:employee)
      create_voucher(%{employee: employee})
      create_voucher()

      conn = get(conn, Routes.voucher_path(conn, :index, employee_id: employee.id))

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      assert List.first(vouchers)["employee"]["id"] == employee.id
    end

    test "list all vouchers that belongs to a company", %{conn: conn} do
      company = insert(:company)
      employee = insert(:employee, %{company: company})
      create_voucher(%{employee: employee})
      create_voucher()

      conn = get(conn, Routes.voucher_path(conn, :index, company_id: company.id))

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 1

      assert List.first(vouchers)["company"]["id"] == company.id
    end

    test "return a voucher by voucher_id", %{conn: conn} do
      voucher = create_voucher()

      conn = get(conn, Routes.voucher_path(conn, :index, voucher_id: voucher.id))

      voucher_returned = json_response(conn, 200)["data"]

      assert is_list(voucher_returned)
      assert Enum.count(voucher_returned) == 1

      assert List.first(voucher_returned)["id"] == voucher.id
    end
  end

  describe "GET /index, when user is taxi" do
    setup [:authenticate_taxi]

    test "list all vouchers that belongs to the taxi", %{conn: conn, taxi: taxi} do
      insert_list(5, :voucher, %{taxi: taxi})
      insert_list(3, :voucher)

      conn = get(conn, Routes.voucher_path(conn, :index))

      taxi_vouchers = json_response(conn, 200)["data"]

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 5
      assert Enum.all?(taxi_vouchers, fn voucher -> voucher["taxi"]["id"] == taxi.id end)
    end

    test "list all vouchers that belongs to the taxi that were paid during or after a date",
         %{conn: conn, taxi: taxi} do
      create_voucher(%{taxi: taxi, payed_at: start_date()})
      create_voucher(%{taxi: taxi, payed_at: pre_start_date()})
      create_voucher(%{payed_at: start_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, payed_start_at: DateTime.to_string(start_date()))
        )

      taxi_vouchers = json_response(conn, 200)["data"]

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher["taxi"]["id"] == taxi.id
      assert parse_date(voucher["payed_at"]) >= start_date()
    end

    test "list all vouchers that belongs to the taxi that were paid before or during a date",
         %{conn: conn, taxi: taxi} do
      create_voucher(%{taxi: taxi, payed_at: end_date()})
      create_voucher(%{taxi: taxi, payed_at: post_end_date()})
      create_voucher(%{payed_at: end_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, payed_end_at: DateTime.to_string(end_date()))
        )

      taxi_vouchers = json_response(conn, 200)["data"]

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher["taxi"]["id"] == taxi.id
      assert parse_date(voucher["payed_at"]) <= end_date()
    end

    test "list all vouchers that belongs to the taxi that were paid between a date interval",
         %{conn: conn, taxi: taxi} do
      create_voucher(%{taxi: taxi, payed_at: between_start_and_end_dates()})
      create_voucher(%{taxi: taxi, payed_at: pre_start_date()})
      create_voucher(%{taxi: taxi, payed_at: post_end_date()})
      create_voucher(%{payed_at: between_start_and_end_dates()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index,
            payed_start_at: DateTime.to_string(start_date()),
            payed_end_at: DateTime.to_string(end_date())
          )
        )

      taxi_vouchers = json_response(conn, 200)["data"]

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher["taxi"]["id"] == taxi.id
      assert Timex.between?(parse_date(voucher["payed_at"]), start_date(), end_date())
    end

    test "list all vouchers that belongs to the taxi that were created during or after a date",
         %{conn: conn, taxi: taxi} do
      create_voucher(%{taxi: taxi, inserted_at: start_date()})
      create_voucher(%{taxi: taxi, inserted_at: pre_start_date()})
      create_voucher(%{inserted_at: start_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, created_start_at: DateTime.to_string(start_date()))
        )

      taxi_vouchers = json_response(conn, 200)["data"]

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher["taxi"]["id"] == taxi.id
      assert parse_date(voucher["inserted_at"]) >= start_date()
    end

    test "list all vouchers that belongs to the taxi that were created before or during a date",
         %{conn: conn, taxi: taxi} do
      create_voucher(%{taxi: taxi, inserted_at: end_date()})
      create_voucher(%{taxi: taxi, inserted_at: post_end_date()})
      create_voucher(%{inserted_at: end_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, created_end_at: DateTime.to_string(end_date()))
        )

      taxi_vouchers = json_response(conn, 200)["data"]

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher["taxi"]["id"] == taxi.id
      assert parse_date(voucher["inserted_at"]) <= end_date()
    end

    test "list all vouchers that belongs to the taxi that were created between date interval",
         %{conn: conn, taxi: taxi} do
      create_voucher(%{taxi: taxi, inserted_at: between_start_and_end_dates()})
      create_voucher(%{taxi: taxi, inserted_at: pre_start_date()})
      create_voucher(%{taxi: taxi, inserted_at: post_end_date()})
      create_voucher(%{inserted_at: between_start_and_end_dates()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index,
            created_start_at: DateTime.to_string(start_date()),
            created_end_at: DateTime.to_string(end_date())
          )
        )

      taxi_vouchers = json_response(conn, 200)["data"]

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 1

      voucher = List.first(taxi_vouchers)

      assert voucher["taxi"]["id"] == taxi.id
      assert Timex.between?(parse_date(voucher["inserted_at"]), start_date(), end_date())
    end
  end

  describe "GET /index, when user is company" do
    setup [:authenticate_company, :create_employee]

    test "list all vouchers that belongs to the company",
         %{conn: conn, company: company, employee: company_employee} do
      insert_list(5, :voucher, %{employee: company_employee})
      insert_list(3, :voucher)

      conn = get(conn, Routes.voucher_path(conn, :index))

      company_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 5
      assert Enum.all?(company_vouchers, fn voucher -> voucher["company"]["id"] == company.id end)
    end

    test "list all vouchers that belongs to the company that were paid during or after a date",
         %{conn: conn, company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, payed_at: start_date()})
      create_voucher(%{employee: company_employee, payed_at: pre_start_date()})
      create_voucher(%{payed_at: start_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, payed_start_at: DateTime.to_string(start_date()))
        )

      company_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher["company"]["id"] == company.id
      assert parse_date(voucher["payed_at"]) >= start_date()
    end

    test "list all vouchers that belongs to the company that were paid before or during a date",
         %{conn: conn, company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, payed_at: end_date()})
      create_voucher(%{employee: company_employee, payed_at: post_end_date()})
      create_voucher(%{payed_at: end_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, payed_end_at: DateTime.to_string(end_date()))
        )

      company_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher["company"]["id"] == company.id
      assert parse_date(voucher["payed_at"]) <= end_date()
    end

    test "list all vouchers that belongs to the company that were paid between a date interval",
         %{conn: conn, company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, payed_at: between_start_and_end_dates()})
      create_voucher(%{employee: company_employee, payed_at: pre_start_date()})
      create_voucher(%{employee: company_employee, payed_at: post_end_date()})
      create_voucher(%{payed_at: between_start_and_end_dates()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index,
            payed_start_at: DateTime.to_string(start_date()),
            payed_end_at: DateTime.to_string(end_date())
          )
        )

      company_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher["company"]["id"] == company.id
      assert Timex.between?(parse_date(voucher["payed_at"]), start_date(), end_date())
    end

    test "list all vouchers that belongs to the company that were created during or after a date",
         %{conn: conn, company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, inserted_at: start_date()})
      create_voucher(%{employee: company_employee, inserted_at: pre_start_date()})
      create_voucher(%{inserted_at: start_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, created_start_at: DateTime.to_string(start_date()))
        )

      company_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher["company"]["id"] == company.id
      assert parse_date(voucher["inserted_at"]) >= start_date()
    end

    test "list all vouchers that belongs to the company that were created before or during a date",
         %{conn: conn, company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, inserted_at: end_date()})
      create_voucher(%{employee: company_employee, inserted_at: post_end_date()})
      create_voucher(%{inserted_at: end_date()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index, created_end_at: DateTime.to_string(end_date()))
        )

      company_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher["company"]["id"] == company.id
      assert parse_date(voucher["inserted_at"]) <= end_date()
    end

    test "list all vouchers that belongs to the company that were created between date interval",
         %{conn: conn, company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee, inserted_at: between_start_and_end_dates()})
      create_voucher(%{employee: company_employee, inserted_at: pre_start_date()})
      create_voucher(%{employee: company_employee, inserted_at: post_end_date()})
      create_voucher(%{inserted_at: between_start_and_end_dates()})

      conn =
        get(
          conn,
          Routes.voucher_path(conn, :index,
            created_start_at: DateTime.to_string(start_date()),
            created_end_at: DateTime.to_string(end_date())
          )
        )

      company_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 1

      voucher = List.first(company_vouchers)

      assert voucher["company"]["id"] == company.id
      assert Timex.between?(parse_date(voucher["inserted_at"]), start_date(), end_date())
    end

    test "list all vouchers that belongs to an employee of the company by employee_id",
         %{conn: conn, company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee})
      create_voucher()

      conn = get(conn, Routes.voucher_path(conn, :index, employee_id: company_employee.id))

      company_employee_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_employee_vouchers)
      assert Enum.count(company_employee_vouchers) == 1

      voucher = List.first(company_employee_vouchers)

      assert voucher["company"]["id"] == company.id
      assert voucher["employee"]["id"] == company_employee.id
    end

    test "list all vouchers that belongs to an employee of the company by internal_id",
         %{conn: conn, company: company, employee: company_employee} do
      create_voucher(%{employee: company_employee})
      create_voucher()

      conn = get(conn, Routes.voucher_path(conn, :index, matricula: company_employee.internal_id))

      company_employee_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_employee_vouchers)
      assert Enum.count(company_employee_vouchers) == 1

      voucher = List.first(company_employee_vouchers)

      assert voucher["company"]["id"] == company.id

      assert voucher["employee"]["internal_id"] == company_employee.internal_id
    end

    test "list all vouchers that belongs to an sector of the company",
         %{conn: conn, company: company, employee: company_employee} do
      company_sector = insert(:sector, %{company: company})

      company_employee_of_another_sector =
        insert(:employee, %{company: company, sector: company_sector})

      create_voucher(%{employee: company_employee})
      create_voucher(%{employee: company_employee_of_another_sector})
      create_voucher()

      conn = get(conn, Routes.voucher_path(conn, :index, sector_id: company_sector.id))

      company_sector_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_sector_vouchers)
      assert Enum.count(company_sector_vouchers) == 1

      voucher = List.first(company_sector_vouchers)

      assert voucher["company"]["id"] == company.id
      assert voucher["employee"]["sector"]["id"] == company_sector.id
    end
  end

  describe "GET /show" do
    setup [:authenticate_taxi]

    test "renders voucher", %{conn: conn} do
      voucher = create_voucher()
      conn = get(conn, Routes.voucher_path(conn, :show, voucher))

      assert json_response(conn, 200) ==
               render_json(VoucherView, "show.json", %{voucher: voucher})
    end
  end

  describe "POST /create" do
    setup [:authenticate_taxi]

    test "renders voucher when data is valid", %{conn: conn} do
      conn = post(conn, Routes.voucher_path(conn, :create), voucher: create_attrs())

      voucher = Vouchers.get_voucher!(json_response(conn, 201)["data"]["id"])

      assert json_response(conn, 201) ==
               render_json(VoucherView, "show.json", %{voucher: voucher})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.voucher_path(conn, :create, voucher: @invalid_attrs))

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PATCH /update" do
    setup [:authenticate_admin]

    test "renders voucher when data is valid", %{conn: conn} do
      ids = insert_list(10, :voucher) |> Enum.map(& &1.id)

      conn = patch(conn, Routes.voucher_path(conn, :update), vouchers: ids)

      assert json_response(conn, 200) ==
               render_json(VoucherView, "update.json", %{count: Enum.count(ids)})
    end
  end

  defp authenticate_admin(%{conn: conn}) do
    authenticate(conn, insert(:admin))
  end

  defp authenticate_company(%{conn: conn}) do
    authenticate(conn, insert(:company))
  end

  defp authenticate_taxi(%{conn: conn}) do
    authenticate(conn, insert(:taxi))
  end

  defp create_attrs do
    params_for(:voucher, %{employee: insert(:employee), taxi: insert(:taxi)})
  end

  defp create_voucher(attrs \\ %{}) do
    insert(:voucher, attrs)
  end

  defp create_employee(%{company: company}) do
    %{employee: insert(:employee, %{company: company})}
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

  defp parse_date(string_date) do
    {:ok, date} = Timex.parse(string_date, "{ISO:Extended:Z}")
    date
  end
end
