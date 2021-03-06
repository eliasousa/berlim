defmodule Berlim.CompanyAccounts.CompanyTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.CompanyAccounts.Company

  @valid_attrs params_for(:company, %{password: "1234abcd"})

  test "changeset/2 with valid attributes" do
    changeset = Company.changeset(%Company{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with invalid attributes" do
    changeset = Company.changeset(%Company{}, %{})
    refute changeset.valid?
  end

  test "create_changeset/2 with valid attributes" do
    changeset = Company.create_changeset(%Company{}, @valid_attrs)
    assert changeset.valid?
  end

  test "create_changeset/2 with invalid attributes" do
    changeset = Company.create_changeset(%Company{}, %{})
    refute changeset.valid?
  end

  test "password is required" do
    attrs = %{@valid_attrs | password: ""}
    changeset = Company.create_changeset(%Company{}, attrs)
    assert %{password: ["can't be blank"]} = errors_on(changeset)
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

  test "email is case insensitive" do
    insert(:company, email: "johndoe@voo.com")

    assert %Company{} = Repo.get_by(Company, email: "johndoe@voo.com")
    assert %Company{} = Repo.get_by(Company, email: "JOHNDOE@VOO.COM")
  end
end
