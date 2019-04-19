defmodule Berlim.Vouchers.Voucher do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.{
    CompanyAccounts.Employee,
    InternalAccounts.Taxi,
    InternalAccounts.Admin
  }

  schema "vouchers" do
    field :from, :string
    field :km, :string
    field :note, :string
    field :to, :string
    field :value, :float
    field :payed_at, :utc_datetime
    belongs_to :employee, Employee
    belongs_to :taxi, Taxi
    belongs_to :admin, Admin, foreign_key: :payed_by

    timestamps()
  end

  @doc false
  def changeset(voucher, admin, attrs) do
    voucher
    |> cast(attrs, [:from, :km, :note, :to, :value, :payed_at, :employee_id, :taxi_id])
    |> validate_required([:value, :from, :to, :taxi_id, :employee_id])
    |> foreign_key_constraint(:taxi_id)
    |> foreign_key_constraint(:employee_id)
    |> put_assoc(:admin, admin)
  end
end
