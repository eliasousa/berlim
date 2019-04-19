defmodule Berlim.InternalAccounts.Taxi do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  import Bcrypt, only: [hash_pwd_salt: 1]

  alias Berlim.Vouchers.Voucher

  schema "taxis" do
    field(:cpf, :string)
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:phone, :string)
    field(:smtt, :integer)
    field(:active, :boolean)
    has_many :vouchers, Voucher

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
       ),
       do: put_change(changeset, :encrypted_password, hash_pwd_salt(password))

  defp put_pass_hash(changeset), do: changeset
end
