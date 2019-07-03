defmodule Berlim.CompanyAccounts.Employee do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt, only: [hash_pwd_salt: 1]

  alias Berlim.{
    CompanyAccounts.Company,
    CompanyAccounts.Sector,
    Vouchers.Voucher
  }

  schema "employees" do
    field :active, :boolean, default: true
    field :internal_id, :string
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    belongs_to :company, Company
    belongs_to :sector, Sector
    has_many :vouchers, Voucher

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :email, :internal_id, :active, :password, :sector_id])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> foreign_key_constraint(:sector_id)
    |> put_pass_hash()
  end

  def create_changeset(employee, company, attrs) do
    employee
    |> changeset(attrs)
    |> validate_required(:password)
    |> put_assoc(:company, company)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset),
    do: put_change(changeset, :encrypted_password, hash_pwd_salt(password))

  defp put_pass_hash(changeset), do: changeset
end
