defmodule Berlim.InternalAccounts.TaxiTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.InternalAccounts.Taxi

  @valid_attrs params_for(:taxi)

  test "changeset with valid attributes" do
    changeset = Taxi.changeset(%Taxi{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Taxi.changeset(%Taxi{}, %{})
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "johndoe.com"}
    changeset = Taxi.changeset(%Taxi{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end
end
