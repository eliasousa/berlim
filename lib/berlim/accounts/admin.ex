defmodule Berlim.Accounts.Admin do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Comeonin.Bcrypt

  schema "admins" do
    field(:email, :string)
    field(:name, :string)
    field(:encrypted_password, :string)
    field(:phone, :string)
    field(:active, :boolean)

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:email, :encrypted_password, :name, :active, :phone])
    |> validate_required([:email, :encrypted_password, :name, :active])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
