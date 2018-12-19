defmodule Berlim.Accounts.TaxiTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.Accounts.Taxi

  test "changeset with valid attributes" do
    valid_attrs = Map.merge(params_for(:taxi), %{plan_id: insert(:plan).id})

    changeset = Taxi.changeset(%Taxi{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Taxi.changeset(%Taxi{}, %{})
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    valid_attrs = Map.merge(params_for(:taxi), %{plan_id: insert(:plan).id})

    attrs = %{valid_attrs | email: "johndoe.com"}
    changeset = Taxi.changeset(%Taxi{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end
end
