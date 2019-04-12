defmodule Berlim.CompanyAccounts.Employee do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.CompanyAccounts.{Company, Sector}

  schema "employees" do
    field :active, :boolean, default: true
    field :internal_id, :string
    field :name, :string
    field :email, :string
    belongs_to :company, Company
    belongs_to :sector, Sector

    timestamps()
  end

  @doc false
  def changeset(employee, company, attrs) do
    employee
    |> cast(attrs, [:name, :email, :internal_id, :active, :sector_id])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> put_assoc(:company, company)
    |> foreign_key_constraint(:sector_id)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :email, :internal_id, :active, :sector_id])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> foreign_key_constraint(:sector_id)
  end
end
