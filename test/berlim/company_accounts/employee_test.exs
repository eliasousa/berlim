defmodule Berlim.CompanyAccounts.EmployeeTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.CompanyAccounts.Employee

  test "changeset/2 with valid attributes" do
    changeset = Employee.changeset(%Employee{}, employee_params())
    assert changeset.valid?
  end

  test "changeset/2 with invalid attributes" do
    changeset = Employee.changeset(%Employee{}, %{})
    refute changeset.valid?
  end

  test "changeset/3 with valid attributes" do
    changeset = Employee.changeset(%Employee{}, insert(:company), employee_params())
    assert changeset.valid?
  end

  test "changeset/3 with invalid attributes" do
    changeset = Employee.changeset(%Employee{}, insert(:company), %{})
    refute changeset.valid?
  end

  test "sector does not exist" do
    attrs = %{employee_params() | sector_id: 0}
    employee = Employee.changeset(%Employee{}, insert(:company), attrs)

    assert {:error, changeset} = Repo.insert(employee)
    assert %{sector_id: ["does not exist"]} = errors_on(changeset)
  end

  defp employee_params do
    params_with_assocs(:employee)
  end
end
