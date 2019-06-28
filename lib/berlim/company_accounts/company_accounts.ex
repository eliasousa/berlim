defmodule Berlim.CompanyAccounts do
  @moduledoc """
  The CompanyAccounts context.
  """

  import Ecto.Query

  alias Berlim.{
    CompanyAccounts.Company,
    CompanyAccounts.Employee,
    CompanyAccounts.Sector,
    EmailGenerator,
    Mailer,
    Repo
  }

  def list_companies, do: Repo.all(Company)

  def get_company!(id), do: Repo.get!(Company, id)

  def create_company(company_attrs) do
    changeset = change_company(%Company{}, company_attrs)

    with {:ok, company} <- Repo.insert(changeset) do
      send_welcome_email(company.email, company.email, get_password(company_attrs))

      {:ok, company}
    end
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
    Sector
    |> where([s], s.company_id == ^company_id)
    |> Repo.all()
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

  def list_company_employees_with_sector(company_id) do
    Employee
    |> where([e], e.company_id == ^company_id)
    |> preload(:sector)
    |> Repo.all()
  end

  def get_employee!(id, company_id) do
    Employee
    |> Repo.get_by!(id: id, company_id: company_id)
    |> Repo.preload(:sector)
  end

  def create_employee(company, employee_attrs) do
    changeset = Employee.changeset(%Employee{}, company, employee_attrs)

    with {:ok, employee} <- Repo.insert(changeset) do
      send_welcome_email(employee.email, employee.id, get_password(employee_attrs))

      {:ok, Repo.preload(employee, :sector)}
    end
  end

  def update_employee(employee, employee_attrs) do
    changeset = Employee.changeset(employee, employee_attrs)

    with {:ok, employee} <- Repo.update(changeset) do
      {:ok, Repo.preload(employee, :sector)}
    end
  end

  defp get_password(%{"encrypted_password" => password}), do: password
  defp get_password(%{encrypted_password: password}), do: password

  defp send_welcome_email(email, username, password) do
    email |> EmailGenerator.welcome(username, password) |> Mailer.deliver()
  end
end
