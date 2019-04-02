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
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :internal_id, :active, :company_id, :sector_id])
    |> validate_required([:name])
    |> cast_or_constraint_assoc(:company)
    |> cast_or_constraint_assoc(:sector)
  end

  defp cast_or_constraint_assoc(changeset, name) do
    {:assoc, %{owner_key: key}} = changeset.types[name]

    if changeset.changes[key] do
      assoc_constraint(changeset, name)
    else
      cast_assoc(changeset, name, required: true)
    end
  end
end
