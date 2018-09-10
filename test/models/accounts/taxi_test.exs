defmodule Berlim.Accounts.TaxiTest do
  use Berlim.ModelCase

  alias Berlim.Accounts.Taxi

  @valid_attrs %{
    email: "johndoe@example.com",
    password: "1234abcd",
    active: true,
    phone: "7932120600",
    smtt: 1234,
    cpf: "02005445698"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Taxi.changeset(%Taxi{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Taxi.changeset(%Taxi{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    assert {:email, "has invalid format"} in errors_on(%Taxi{}, %{email: "johndoe.com"})
  end
end
