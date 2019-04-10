defmodule Berlim.CompanyAccountsTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.CompanyAccounts

  describe "companies" do
    alias Berlim.CompanyAccounts.Company

    @valid_attrs params_for(:company)
    @update_attrs %{name: "Jaya"}
    @invalid_attrs %{cnpj: nil, email: nil}

    test "list_companies/0 returns all companies" do
      company = insert(:company)
      assert CompanyAccounts.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = insert(:company)
      assert CompanyAccounts.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, company} = CompanyAccounts.create_company(@valid_attrs)
      assert company.active == true
      assert company.name == "Voo de Taxi"
      assert Bcrypt.check_pass(company, "1234abcd") == {:ok, company}
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CompanyAccounts.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = insert(:company)
      assert {:ok, company} = CompanyAccounts.update_company(company, @update_attrs)
      assert %Company{} = company
      assert company.name == "Jaya"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = insert(:company)
      assert {:error, %Ecto.Changeset{}} = CompanyAccounts.update_company(company, @invalid_attrs)
    end

    test "change_company/0 returns a company changeset" do
      assert %Ecto.Changeset{} = CompanyAccounts.change_company()
    end

    test "change_company/1 returns a company changeset" do
      company = insert(:company)
      assert %Ecto.Changeset{} = CompanyAccounts.change_company(company)
    end

    test "change_company/2 returns a company changeset" do
      company = insert(:company)
      assert %Ecto.Changeset{} = CompanyAccounts.change_company(company, @update_attrs)
    end
  end

  describe "sectors" do
    alias Berlim.CompanyAccounts.Sector
    import Berlim.Helpers.Unpreloader

    @update_attrs %{name: "Recursos Humanos"}
    @invalid_attrs %{name: nil}

    defp sector_params do
      params_with_assocs(:sector)
    end

    test "list_company_sectors/1, return all sectors that belongs to a company" do
      sector = unpreload(insert(:sector), :company)
      _another_sector = insert(:sector)

      assert CompanyAccounts.list_company_sectors(sector.company_id) == [sector]
    end

    test "get_sector!/2, returns the sector with the given id and company id" do
      sector = unpreload(insert(:sector), :company)
      assert CompanyAccounts.get_sector!(sector.id, sector.company_id) == sector
    end

    test "create_sector/1 with valid data, creates a sector" do
      assert {:ok, sector} = CompanyAccounts.create_sector(sector_params())
      assert sector.name == "Financeiro"
    end

    test "create_sector/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CompanyAccounts.create_sector(@invalid_attrs)
    end

    test "update_sector/2 with valid data, updates the sector" do
      sector = insert(:sector)
      assert {:ok, sector} = CompanyAccounts.update_sector(sector, @update_attrs)
      assert sector.name == "Recursos Humanos"
    end

    test "update_sector/2 with invalid data, returns error changeset" do
      sector = insert(:sector)
      assert {:error, %Ecto.Changeset{}} = CompanyAccounts.update_sector(sector, @invalid_attrs)
    end

    test "change_sector/0, returns a Sector changeset" do
      changeset = CompanyAccounts.change_sector()

      assert %Ecto.Changeset{} = changeset
      assert %Sector{} = changeset.data
    end

    test "change_sector/1, returns a Sector changeset" do
      changeset = CompanyAccounts.change_sector(insert(:sector))

      assert %Ecto.Changeset{} = changeset
      assert %Sector{} = changeset.data
    end

    test "change_sector/2, returns a Sector changeset" do
      changeset = CompanyAccounts.change_sector(insert(:sector), @update_attrs)

      assert %Ecto.Changeset{} = changeset
      assert %Sector{} = changeset.data
    end
  end

  describe "employees" do
    alias Berlim.CompanyAccounts.Employee
    import Berlim.Helpers.Unpreloader

    @update_attrs %{name: "Elias", internal_id: "4321dcba"}
    @invalid_attrs %{name: nil}

    defp employee_params do
      params_with_assocs(:employee)
    end

    test "list_company_employees/1, returns all employees that belongs to a company" do
      employee = unpreload(insert(:employee), [:company, :sector])
      _another_employee = insert(:employee)

      assert CompanyAccounts.list_company_employees(employee.company_id) == [employee]
    end

    test "get_employee!/2, returns the employee with the given id and company id" do
      employee = unpreload(insert(:employee), [:company, :sector])
      assert CompanyAccounts.get_employee!(employee.id, employee.company_id) == employee
    end

    test "create_employee/1 with valid data, creates a employee" do
      assert {:ok, employee} = CompanyAccounts.create_employee(employee_params())
      assert employee.name == "Danilo"
    end

    test "create_employee/1 with invalid data, returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CompanyAccounts.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data, updates the employee" do
      employee = insert(:employee)

      assert {:ok, employee} = CompanyAccounts.update_employee(employee, @update_attrs)
      assert employee.name == "Elias"
      assert employee.internal_id == "4321dcba"
    end

    test "update_employee/2 with invalid data, returns error changeset" do
      employee = insert(:employee)

      assert {:error, %Ecto.Changeset{}} =
               CompanyAccounts.update_employee(employee, @invalid_attrs)
    end

    test "change_employee/0, returns a Employee changeset" do
      changeset = CompanyAccounts.change_employee()

      assert %Ecto.Changeset{} = changeset
      assert %Employee{} = changeset.data
    end

    test "change_employee/1, returns a Employee changeset" do
      changeset = CompanyAccounts.change_employee(insert(:employee))

      assert %Ecto.Changeset{} = changeset
      assert %Employee{} = changeset.data
    end

    test "change_employee/2, returns a Employee changeset" do
      changeset = CompanyAccounts.change_employee(insert(:employee), @update_attrs)

      assert %Ecto.Changeset{} = changeset
      assert %Employee{} = changeset.data
    end
  end
end
