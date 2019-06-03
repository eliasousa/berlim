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
    belongs_to :payed_by, Admin, foreign_key: :payed_by_id

    timestamps()
  end

  @doc false
  def changeset(voucher, admin, attrs) do
    voucher
    |> default_changeset(attrs)
    |> put_assoc(:payed_by, admin)
  end

  @doc false
  def changeset(voucher, attrs) do
    default_changeset(voucher, attrs)
  end

  defp default_changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:from, :km, :note, :to, :value, :payed_at, :employee_id, :taxi_id])
    |> validate_required([:value, :from, :to, :taxi_id, :employee_id])
    |> foreign_key_constraint(:taxi_id)
    |> foreign_key_constraint(:employee_id)
  end
end
