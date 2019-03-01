defmodule Berlim.InternalAccounts.AdminTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.InternalAccounts.Admin

  @valid_attrs params_for(:admin)

  test "changeset with valid attributes" do
    changeset = Admin.changeset(%Admin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Admin.changeset(%Admin{}, %{})
    refute changeset.valid?
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
end
