defmodule BerlimWeb.CompanyController do
  use BerlimWeb, :controller

  alias Berlim.CompanyAccounts
  alias Berlim.CompanyAccounts.Company

  action_fallback BerlimWeb.FallbackController

  def index(conn, _params) do
    companies = CompanyAccounts.list_companies()
    render(conn, "index.json", companies: companies)
  end

  def create(conn, %{"company" => company_params}) do
    with {:ok, %Company{} = company} <- CompanyAccounts.create_company(company_params) do
      conn
      |> put_status(:created)
      |> render("show.json", company: company)
    end
  end

  def show(conn, %{"id" => id}) do
    company = CompanyAccounts.get_company!(id)
    render(conn, "show.json", company: company)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = CompanyAccounts.get_company!(id)

    with {:ok, %Company{} = company} <- CompanyAccounts.update_company(company, company_params) do
      render(conn, "show.json", company: company)
    end
  end
end
