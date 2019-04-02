defmodule BerlimWeb.EmployeeController do
  use BerlimWeb, :controller

  alias Berlim.CompanyAccounts
  alias Berlim.CompanyAccounts.Employee

  action_fallback BerlimWeb.FallbackController

  def index(conn, %{"company_id" => company_id}) do
    employees = CompanyAccounts.list_company_employees(company_id)
    render(conn, "index.json", employees: employees)
  end

  def create(conn, %{"employee" => employee_params, "company_id" => company_id}) do
    employee_params = Map.put(employee_params, "company_id", company_id)

    with {:ok, %Employee{} = employee} <- CompanyAccounts.create_employee(employee_params) do
      conn
      |> put_status(:created)
      |> render("show.json", employee: employee)
    end
  end

  def show(conn, %{"id" => id}) do
    employee = CompanyAccounts.get_employee!(id)
    render(conn, "show.json", employee: employee)
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    employee = CompanyAccounts.get_employee!(id)

    with {:ok, %Employee{} = employee} <-
           CompanyAccounts.update_employee(employee, employee_params) do
      render(conn, "show.json", employee: employee)
    end
  end
end
