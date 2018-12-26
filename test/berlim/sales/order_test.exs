defmodule Berlim.Sales.OrderTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.Sales.Order

  test "changeset with valid attributes" do
    taxi = insert(:taxi)
    valid_attrs = Map.merge(params_for(:order), %{taxi_id: taxi.id})
    changeset = Order.changeset(%Order{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, %{})
    refute changeset.valid?
  end
end
