defmodule Berlim.Sales.CustomerTest do
  use Berlim.DataCase

  alias Berlim.Sales.Customer

  @valid_attrs %{
    fullname: "John Doe",
    email: "johndoe@example.com",
    phone: "7932120600",
    address_street: "Rua A",
    address_street_number: "3",
    address_complement: "Prox a farmacia",
    address_city_code: 54,
    address_city_name: "Aracaju",
    address_state: "SE",
    address_zipcode: "49140000",
    address_district: "Ponto Novo",
    address_country: "BRA"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Customer.changeset(%Customer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Customer.changeset(%Customer{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "johndoe.com"}
    changeset = Customer.changeset(%Customer{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end
end
