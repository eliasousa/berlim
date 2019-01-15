defmodule Berlim.Accounts.Taxi do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.Sales.{
    Order,
    Plan
  }

  alias Comeonin.Bcrypt

  schema "taxis" do
    field(:cpf, :string)
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:phone, :string)
    field(:smtt, :integer)
    field(:active, :boolean)
    has_many(:orders, Order)
    belongs_to(:plan, Plan)

    timestamps()
  end

  @doc false
  def changeset(taxi, attrs) do
    taxi
    |> cast(attrs, [:email, :encrypted_password, :active, :phone, :smtt, :cpf, :plan_id])
    |> validate_required([:email, :encrypted_password, :active, :phone, :smtt, :cpf, :plan_id])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:smtt)
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
