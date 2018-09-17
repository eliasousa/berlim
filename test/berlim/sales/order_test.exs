defmodule Berlim.Sales.OrderTest do
  use Berlim.DataCase

  alias Berlim.Sales.Order

  @valid_attrs %{
    value: 150,
    status: :approved,
    type: :credit_card,
    approved_at: DateTime.utc_now(),
    monthly_date: Date.utc_today()
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, @invalid_attrs)
    refute changeset.valid?
  end
end
