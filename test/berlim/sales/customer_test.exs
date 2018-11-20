defmodule Berlim.Sales.CustomerTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.Sales.Customer

  @valid_attrs params_for(:customer)

  test "changeset with valid attributes" do
    changeset = Customer.changeset(%Customer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Customer.changeset(%Customer{}, %{})
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "johndoe.com"}
    changeset = Customer.changeset(%Customer{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end
end
