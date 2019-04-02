defmodule Berlim.CompanyAccounts.EmployeeTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.CompanyAccounts.Employee

  test "changeset with valid attributes" do
    changeset = Employee.changeset(%Employee{}, employee_params())
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Employee.changeset(%Employee{}, %{})
    refute changeset.valid?
  end

  test "company does not exist" do
    attrs = %{employee_params() | company_id: 0}
    employee = Employee.changeset(%Employee{}, attrs)

    assert {:error, changeset} = Repo.insert(employee)
    assert %{company: ["does not exist"]} = errors_on(changeset)
  end

  test "company is required" do
    changeset = Employee.changeset(%Employee{}, params_for(:employee))
    assert %{company: ["can't be blank"]} = errors_on(changeset)
  end

  test "sector does not exist" do
    attrs = %{employee_params() | sector_id: 0}
    employee = Employee.changeset(%Employee{}, attrs)

    assert {:error, changeset} = Repo.insert(employee)
    assert %{sector: ["does not exist"]} = errors_on(changeset)
  end

  test "sector is required" do
    changeset = Employee.changeset(%Employee{}, params_for(:employee))
    assert %{sector: ["can't be blank"]} = errors_on(changeset)
  end

  defp employee_params do
    params_with_assocs(:employee)
  end
end
