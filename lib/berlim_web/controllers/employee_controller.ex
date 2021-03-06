defmodule BerlimWeb.EmployeeController do
  use BerlimWeb, :controller

  alias Berlim.{
    CompanyAccounts,
    CompanyAccounts.Employee
  }

  action_fallback BerlimWeb.FallbackController

  def index(%{assigns: %{company: company}} = conn, _params) do
    employees = CompanyAccounts.list_company_employees_with_sector(company.id)
    render(conn, "index.json", employees: employees)
  end

  def create(%{assigns: %{company: company}} = conn, %{"employee" => employee_params}) do
    with {:ok, %Employee{} = employee} <-
           CompanyAccounts.create_employee(company, employee_params) do
      conn
      |> put_status(:created)
      |> render("show.json", employee: employee)
    end
  end

  def show(%{assigns: %{company: company}} = conn, %{"id" => id}) do
    employee = CompanyAccounts.get_employee!(id, company.id)
    render(conn, "show.json", employee: employee)
  end

  def update(%{assigns: %{company: company}} = conn, %{"id" => id, "employee" => employee_params}) do
    employee = CompanyAccounts.get_employee!(id, company.id)

    with {:ok, %Employee{} = employee} <-
           CompanyAccounts.update_employee(employee, employee_params) do
      render(conn, "show.json", employee: employee)
    end
  end
end
