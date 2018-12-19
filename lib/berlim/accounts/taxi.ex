defmodule Berlim.Accounts.Taxi do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.Sales.{Order, Plan}

  schema "taxis" do
    field(:cpf, :string)
    field(:email, :string)
    field(:password, :string)
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
    |> cast(attrs, [:email, :password, :active, :phone, :smtt, :cpf, :plan_id])
    |> validate_required([:email, :password, :active, :phone, :smtt, :cpf, :plan_id])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:smtt)
    |> unique_constraint(:email)
  end
end
