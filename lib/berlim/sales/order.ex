defmodule Berlim.Sales.Order do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Berlim.Accounts.Taxi
  alias Berlim.Sales.Customer

  defmodule Status do
    @moduledoc false
    use Exnumerator, values: [approved: "Aprovado", pending: "Pendente", refused: "Recusado"]
  end

  defmodule Type do
    @moduledoc false
    use Exnumerator, values: [credit_card: "Cartão de Crédito", bank_slip: "Boleto Bancário"]
  end

  schema "orders" do
    field(:monthly_date, :date)
    field(:approved_at, :utc_datetime)
    field(:status, Status)
    field(:type, Type)
    field(:value, :float)
    belongs_to(:taxi, Taxi)
    belongs_to(:customer, Customer)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:value, :status, :type, :approved_at, :monthly_date])
    |> validate_required([:value, :status, :type, :monthly_date])
  end
end
