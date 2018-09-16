defmodule Berlim.Sales.Customer do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.Sales.Order

  schema "customers" do
    field(:address_city_code, :integer)
    field(:address_city_name, :string)
    field(:address_complement, :string)
    field(:address_country, :string)
    field(:address_district, :string)
    field(:address_state, :string)
    field(:address_street, :string)
    field(:address_street_number, :string)
    field(:address_zipcode, :string)
    field(:email, :string)
    field(:fullname, :string)
    field(:phone, :string)
    has_many(:orders, Order)

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [
      :fullname,
      :email,
      :phone,
      :address_street,
      :address_street_number,
      :address_complement,
      :address_city_code,
      :address_city_name,
      :address_state,
      :address_zipcode,
      :address_district,
      :address_country
    ])
    |> validate_required([
      :fullname,
      :email,
      :phone,
      :address_street,
      :address_street_number,
      :address_complement,
      :address_city_code,
      :address_city_name,
      :address_state,
      :address_zipcode,
      :address_district,
      :address_country
    ])
    |> validate_format(:email, ~r/@/)
  end
end
