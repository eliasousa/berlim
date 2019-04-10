defmodule Berlim.CompanyAccounts.Sector do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.CompanyAccounts.{Company, Employee}

  schema "sectors" do
    field :name, :string
    belongs_to :company, Company
    has_many :employees, Employee

    timestamps()
  end

  @doc false
  def changeset(sector, company, attrs) do
    sector
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_assoc(:company, company)
  end

  @doc false
  def changeset(sector, attrs) do
    sector
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
