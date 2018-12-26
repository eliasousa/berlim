defmodule Berlim.Sales.Order do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.{
    Accounts.Taxi,
    Sales.Customer
  }

  defmodule Status do
    @moduledoc false
    use Exnumerator, values: [:approved, :pending, :refused, :paid]
  end

  defmodule Type do
    @moduledoc false
    use Exnumerator, values: [:credit_card, :bank_slip, :money]
  end

  schema "orders" do
    embeds_one(:customer, Customer)
    field(:monthly_date, :date)
    field(:approved_at, :utc_datetime)
    field(:status, Status)
    field(:type, Type)
    field(:value, :float)
    belongs_to(:taxi, Taxi)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:value, :status, :type, :approved_at, :monthly_date, :taxi_id])
    |> validate_required([:value, :status, :type, :monthly_date, :taxi_id])
  end
end
