defmodule Berlim.CompanyAccounts.CompanyTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.CompanyAccounts.Company

  @valid_attrs params_for(:company)

  test "changeset with valid attributes" do
    changeset = Company.changeset(%Company{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Company.changeset(%Company{}, %{})
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "voodetaxi.com"}
    changeset = Company.changeset(%Company{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end

  test "email is unique" do
    company_existent = insert(:company)

    attrs = %{@valid_attrs | email: company_existent.email}
    new_company = Company.changeset(%Company{}, attrs)

    assert {:error, changeset} = Repo.insert(new_company)
    assert %{email: ["has already been taken"]} = errors_on(changeset)
  end

  test "cnpj is unique" do
    company_existent = insert(:company)

    attrs = %{@valid_attrs | cnpj: company_existent.cnpj}
    new_company = Company.changeset(%Company{}, attrs)

    assert {:error, changeset} = Repo.insert(new_company)
    assert %{cnpj: ["has already been taken"]} = errors_on(changeset)
  end
end
