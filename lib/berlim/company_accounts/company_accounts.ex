defmodule Berlim.CompanyAccounts do
  @moduledoc """
  The CompanyAccounts context.
  """

  alias Berlim.{CompanyAccounts.Company, Repo}

  def list_companies, do: Repo.all(Company)

  def get_company!(id), do: Repo.get!(Company, id)

  def create_company(company_attrs) do
    %Company{}
    |> change_company(company_attrs)
    |> Repo.insert()
  end

  def update_company(company, company_attrs) do
    company
    |> change_company(company_attrs)
    |> Repo.update()
  end

  def change_company(company \\ %Company{}, company_attrs \\ %{}) do
    Company.changeset(company, company_attrs)
  end
end
