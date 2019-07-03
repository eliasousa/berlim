defmodule Berlim.InternalAccounts.Admin do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  import Bcrypt, only: [hash_pwd_salt: 1]

  alias Berlim.Vouchers.Voucher

  schema "admins" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:encrypted_password, :string)
    field(:phone, :string)
    field(:active, :boolean)

    has_many :vouchers, Voucher, foreign_key: :payed_by_id

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:email, :password, :name, :active, :phone])
    |> validate_required([:email, :name, :active])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> put_pass_hash()
  end

  def create_changeset(admin, attrs) do
    admin
    |> changeset(attrs)
    |> validate_required(:password)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset),
    do: put_change(changeset, :encrypted_password, hash_pwd_salt(password))

  defp put_pass_hash(changeset), do: changeset
end
