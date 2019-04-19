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

  test "email must contain at least an @" do
    attrs = %{employee_params() | email: "voodetaxi.com"}
    changeset = Employee.changeset(%Employee{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end

  test "email is unique" do
    employee_existent = insert(:employee)

    attrs = %{employee_params() | email: employee_existent.email}
    new_employee = Employee.changeset(%Employee{}, insert(:company), attrs)

    assert {:error, changeset} = Repo.insert(new_employee)
    assert %{email: ["has already been taken"]} = errors_on(changeset)
  end

  test "email is case insensitive" do
    insert(:employee, email: "johndoe@voo.com")

    assert %Employee{} = Repo.get_by(Employee, email: "johndoe@voo.com")
    assert %Employee{} = Repo.get_by(Employee, email: "JOHNDOE@VOO.COM")
  end

  defp employee_params do
    params_with_assocs(:employee)
  end
end
