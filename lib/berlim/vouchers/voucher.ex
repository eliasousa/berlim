defmodule Berlim.Vouchers.Voucher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vouchers" do
    field :from, :string
    field :km, :string
    field :note, :string
    field :payed_at, :utc_datetime
    field :to, :string
    field :value, :float
    field :taxi_id, :id
    field :employee_id, :id
    field :payed_by, :id

    timestamps()
  end

  @doc false
  def changeset(voucher, attrs) do
    voucher
    |> cast(attrs, [:value, :from, :to, :km, :note, :payed_at])
    |> validate_required([:value, :from, :to, :km, :note, :payed_at])
  end
end
