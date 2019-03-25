defmodule Berlim.CompanyAccounts.Sector do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.CompanyAccounts.Company

  schema "sectors" do
    field :name, :string
    belongs_to :company, Company

    timestamps()
  end

  @doc false
  def changeset(sector, attrs) do
    sector
    |> cast(attrs, [:name, :company_id])
    |> validate_required([:name])
    |> cast_or_constraint_assoc(:company)
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
