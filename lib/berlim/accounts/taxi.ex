defmodule Berlim.Accounts.Taxi do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.Sales.Order

  schema "taxis" do
    field(:cpf, :string)
    field(:email, :string)
    field(:password, :string)
    field(:phone, :string)
    field(:smtt, :integer)
    field(:active, :boolean)
    has_many(:orders, Order)

    timestamps()
  end

  @doc false
  def changeset(taxi, attrs \\ %{}) do
    taxi
    |> cast(attrs, [:email, :password, :active, :phone, :smtt, :cpf])
    |> validate_required([:email, :password, :active, :phone, :smtt, :cpf], message: "Campo obrigatório!")
    |> validate_format(:email, ~r/@/, message: "Formato inválido!")
    |> unique_constraint(:smtt, message: "SMTT já cadastrado!")
    |> unique_constraint(:email, message: "Email já cadastrado!")
  end
end
