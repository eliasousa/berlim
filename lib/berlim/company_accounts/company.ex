defmodule Berlim.CompanyAccounts.Company do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  import Bcrypt, only: [hash_pwd_salt: 1]

  alias Berlim.CompanyAccounts.{Employee, Sector}

  schema "companies" do
    field :cnpj, :string
    field :email, :string
    field :encrypted_password, :string
    field :name, :string
    field :phone, :string
    field :active, :boolean, default: true
    has_many :sectors, Sector
    has_many :employees, Employee

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :cnpj, :email, :encrypted_password, :active, :phone])
    |> validate_required([:name, :cnpj, :email, :encrypted_password, :active])
    |> unique_constraint(:email)
    |> unique_constraint(:cnpj)
    |> validate_format(:email, ~r/@/)
    |> put_pass_hash()
  end

  defp put_pass_hash(
         %Ecto.Changeset{valid?: true, changes: %{encrypted_password: password}} = changeset
       ),
       do: put_change(changeset, :encrypted_password, hash_pwd_salt(password))

  defp put_pass_hash(changeset), do: changeset
end
