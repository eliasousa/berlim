defmodule Berlim.InternalAccounts.AdminTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.InternalAccounts.Admin

  @valid_attrs params_for(:admin, %{password: "1234abcd"})

  test "changeset/2 with valid attributes" do
    changeset = Admin.changeset(%Admin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with invalid attributes" do
    changeset = Admin.changeset(%Admin{}, %{})
    refute changeset.valid?
  end

  test "create_changeset/2 with valid attributes" do
    changeset = Admin.create_changeset(%Admin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "create_changeset/2 with invalid attributes" do
    changeset = Admin.create_changeset(%Admin{}, %{})
    refute changeset.valid?
  end

  test "password is required" do
    attrs = %{@valid_attrs | password: ""}
    changeset = Admin.create_changeset(%Admin{}, attrs)
    assert %{password: ["can't be blank"]} = errors_on(changeset)
  end

  test "phone is not required" do
    changeset = Admin.changeset(%Admin{}, Map.delete(@valid_attrs, :phone))
    assert changeset.valid?
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "johndoe.com"}
    changeset = Admin.changeset(%Admin{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end

  test "email is unique" do
    admin_existent = insert(:admin)

    attrs = %{@valid_attrs | email: admin_existent.email}
    new_admin = Admin.changeset(%Admin{}, attrs)

    assert {:error, changeset} = Repo.insert(new_admin)
    assert %{email: ["has already been taken"]} = errors_on(changeset)
  end

  test "email is case insensitive" do
    insert(:admin, email: "johndoe@voo.com")

    assert %Admin{} = Repo.get_by(Admin, email: "johndoe@voo.com")
    assert %Admin{} = Repo.get_by(Admin, email: "JOHNDOE@VOO.COM")
  end
end
