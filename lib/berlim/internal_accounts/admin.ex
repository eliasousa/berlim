defmodule Berlim.InternalAccounts.Admin do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  import Bcrypt, only: [hash_pwd_salt: 1]

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
    |> put_pass_hash()
  end

  defp put_pass_hash(
         %Ecto.Changeset{valid?: true, changes: %{encrypted_password: password}} = changeset
       ),
       do: put_change(changeset, :encrypted_password, hash_pwd_salt(password))

  defp put_pass_hash(changeset), do: changeset
end
