defmodule Berlim.Accounts.Taxi do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Comeonin.Bcrypt

  schema "taxis" do
    field(:cpf, :string)
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:phone, :string)
    field(:smtt, :integer)
    field(:active, :boolean)

    timestamps()
  end

  @doc false
  def changeset(taxi, attrs) do
    taxi
    |> cast(attrs, [:email, :encrypted_password, :active, :phone, :smtt, :cpf])
    |> validate_required([:email, :encrypted_password, :active, :phone, :smtt, :cpf])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:smtt)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(
         %Ecto.Changeset{valid?: true, changes: %{encrypted_password: password}} = changeset
       ) do
    put_change(changeset, :encrypted_password, Bcrypt.hashpwsalt(password))
  end

  defp put_pass_hash(changeset) do
    changeset
  end
end
