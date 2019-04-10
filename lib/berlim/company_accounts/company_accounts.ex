defmodule Berlim.CompanyAccounts do
  @moduledoc """
  The CompanyAccounts context.
  """

  import Ecto.Query, only: [from: 2]

  alias Berlim.{
    CompanyAccounts.Company,
    CompanyAccounts.Employee,
    CompanyAccounts.Sector,
    Repo
  }

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

  def list_company_sectors(company_id) do
    Repo.all(
      from s in Sector,
        where: s.company_id == ^company_id
    )
  end

  def get_sector!(id, company_id), do: Repo.get_by!(Sector, id: id, company_id: company_id)

  def create_sector(company, sector_attrs) do
    %Sector{}
    |> Sector.changeset(company, sector_attrs)
    |> Repo.insert()
  end

  def update_sector(sector, sector_attrs) do
    sector
    |> Repo.preload(:company)
    |> Sector.changeset(sector_attrs)
    |> Repo.update()
  end

  def list_company_employees(company_id) do
    Repo.all(
      from e in Employee,
        where: e.company_id == ^company_id
    )
  end

  def get_employee!(id, company_id), do: Repo.get_by!(Employee, id: id, company_id: company_id)

  def create_employee(company, employee_attrs) do
    %Employee{}
    |> Employee.changeset(company, employee_attrs)
    |> Repo.insert()
  end

  def update_employee(employee, employee_attrs) do
    employee
    |> Repo.preload([:company, :sector])
    |> Employee.changeset(employee_attrs)
    |> Repo.update()
  end
end
