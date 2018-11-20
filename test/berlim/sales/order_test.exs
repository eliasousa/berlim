defmodule Berlim.Sales.OrderTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.Sales.Order

  @valid_attrs params_for(:order)

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, %{})
    refute changeset.valid?
  end
end
