defmodule Berlim.Sales.Plan do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :name, :string
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end
end
