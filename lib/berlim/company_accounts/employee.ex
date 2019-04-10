defmodule Berlim.CompanyAccounts.Employee do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.CompanyAccounts.{Company, Sector}

  schema "employees" do
    field :active, :boolean, default: true
    field :internal_id, :string
    field :name, :string
    belongs_to :company, Company
    belongs_to :sector, Sector

    timestamps()
  end

  @doc false
  def changeset(employee, company, attrs) do
    employee
    |> cast(attrs, [:name, :internal_id, :active, :sector_id])
    |> validate_required([:name])
    |> put_assoc(:company, company)
    |> foreign_key_constraint(:sector_id)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :internal_id, :active, :sector_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:sector_id)
  end
end
