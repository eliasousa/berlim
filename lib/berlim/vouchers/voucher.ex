defmodule Berlim.Vouchers.Voucher do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.{
    CompanyAccounts.Employee,
    InternalAccounts.Admin,
    InternalAccounts.Taxi
  }

  @timestamps_opts [type: :utc_datetime]

  schema "vouchers" do
    field :from, :string
    field :km, :string
    field :note, :string
    field :to, :string
    field :value, :float
    field :paid_at, :utc_datetime
    belongs_to :employee, Employee
    belongs_to :taxi, Taxi
    belongs_to :paid_by, Admin, foreign_key: :paid_by_id

    timestamps()
  end

  @doc false
  def changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:from, :km, :note, :to, :value, :paid_at, :employee_id, :taxi_id])
    |> validate_required([:value, :from, :to, :taxi_id, :employee_id])
    |> foreign_key_constraint(:taxi_id)
    |> foreign_key_constraint(:employee_id)
  end
end
