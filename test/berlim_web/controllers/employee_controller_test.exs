defmodule BerlimWeb.EmployeeControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  alias Berlim.CompanyAccounts

  alias BerlimWeb.EmployeeView

  @update_attrs %{
    active: false,
    internal_id: "789456",
    name: "Elias"
  }
  @invalid_attrs %{name: nil}

  describe "GET /index" do
    setup [:authenticate_company]

    test "lists all employees that belongs to a company", %{
      conn: conn,
      company: company
    } do
      conn = get(conn, Routes.employee_path(conn, :index, company.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "GET /show" do
    setup [:authenticate_company, :create_employee]

    test "renders employee", %{conn: conn, employee: employee} do
      conn = get(conn, Routes.employee_path(conn, :show, employee.company_id, employee))

      assert json_response(conn, 200) ==
               render_json(EmployeeView, "show.json", %{employee: employee})
    end
  end

  describe "POST /create" do
    setup [:authenticate_company]

    test "renders employee when data is valid", %{conn: conn, company: company} do
      conn = post(conn, Routes.employee_path(conn, :create, company, employee: create_attrs()))
      employee = CompanyAccounts.get_employee!(json_response(conn, 201)["data"]["id"])

      assert json_response(conn, 201) ==
               render_json(EmployeeView, "show.json", %{employee: employee})
    end

    test "renders erros when data is invalid", %{conn: conn, company: company} do
      conn = post(conn, Routes.employee_path(conn, :create, company, employee: @invalid_attrs))

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PUT /update" do
    setup [:authenticate_company, :create_employee]

    test "renders employee when data is valid", %{conn: conn, employee: employee} do
      conn =
        put(
          conn,
          Routes.employee_path(conn, :update, employee.company_id, employee,
            employee: @update_attrs
          )
        )

      employee = CompanyAccounts.get_employee!(json_response(conn, 200)["data"]["id"])

      assert json_response(conn, 200) ==
               render_json(EmployeeView, "show.json", %{employee: employee})

      assert json_response(conn, 200)["data"]["name"] == "Elias"
    end

    test "renders errors when data is invalid", %{conn: conn, employee: employee} do
      conn =
        put(
          conn,
          Routes.employee_path(conn, :update, employee.company_id, employee,
            employee: @invalid_attrs
          )
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_attrs do
    params_for(:employee, %{sector: insert(:sector)})
  end

  defp create_employee(%{company: company}) do
    employee =
      :employee
      |> build(%{company: company})
      |> insert()

    %{employee: employee}
  end

  defp authenticate_company(%{conn: conn}) do
    authenticate(conn, insert(:company))
  end
end
