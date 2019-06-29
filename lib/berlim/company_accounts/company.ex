defmodule Berlim.CompanyAccounts.Company do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  import Bcrypt, only: [hash_pwd_salt: 1]

  alias Berlim.CompanyAccounts.{Employee, Sector}

  schema "companies" do
    field :cnpj, :string
    field :email, :string
    field :password, :string, virtual: true
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
    |> cast(attrs, [:name, :cnpj, :email, :password, :active, :phone])
    |> validate_required([:name, :cnpj, :email, :active])
    |> unique_constraint(:email)
    |> unique_constraint(:cnpj)
    |> validate_format(:email, ~r/@/)
    |> put_pass_hash()
  end

  def create_changeset(company, attrs) do
    company
    |> changeset(attrs)
    |> validate_required(:password)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset),
    do: put_change(changeset, :encrypted_password, hash_pwd_salt(password))

  defp put_pass_hash(changeset), do: changeset
end
