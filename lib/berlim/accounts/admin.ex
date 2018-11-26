defmodule Berlim.Accounts.Admin do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "admins" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string)
    field(:phone, :string)
    field(:active, :boolean)

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:email, :password, :name, :active, :phone])
    |> validate_required([:email, :password, :name, :active], message: "Campo obrigatório!")
    |> unique_constraint(:email, message: "Email já cadastrado!")
    |> validate_format(:email, ~r/@/, message: "Formato inválido!")
  end
end
