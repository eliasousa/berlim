defmodule Berlim.Accounts.AdminTest do
  use Berlim.ModelCase

  alias Berlim.Accounts.Admin

  @valid_attrs %{
    email: "johndoe@example.com",
    password: "1234abcd",
    name: "John Doe",
    active: true,
    phone: "7932120600"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Admin.changeset(%Admin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Admin.changeset(%Admin{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "phone is not required" do
    changeset = Admin.changeset(%Admin{}, Map.delete(@valid_attrs, :phone))
    assert changeset.valid?
  end

  test "email must contain at least an @" do
    assert {:email, "has invalid format"} in errors_on(%Admin{}, %{email: "johndoe.com"})
  end
end
