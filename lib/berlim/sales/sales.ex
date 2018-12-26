defmodule Berlim.Sales do
  @moduledoc """
  The Sales context.
  """

  import Berlim.ParseHelpers
  import Ecto.Query, only: [order_by: 2]

  alias Berlim.{
    Repo,
    Sales.Plan,
    Sales.Order,
    Accounts
  }

  def list_plans, do: Repo.all(Plan)

  def get_plan!(id), do: Repo.get!(Plan, id)

  def create_plan(plan_attrs) do
    %Plan{}
    |> change_plan(plan_attrs)
    |> Repo.insert()
  end

  def update_plan(plan, plan_attrs) do
    plan
    |> change_plan(plan_attrs)
    |> Repo.update()
  end

  def change_plan(plan \\ %Plan{}, plan_attrs \\ %{}) do
    Plan.changeset(plan, plan_attrs)
  end

  def list_orders(params) do
    Order
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(params)
  end

  def get_order!(id), do: Repo.get!(Order, id)

  def create_order(%{"taxi_id" => taxi_id, "monthly_date" => monthly_date} = order_attrs) do
    taxi = Accounts.get_taxi!(taxi_id)
    taxi = Repo.preload(taxi, :plan)

    order_attrs =
      Map.merge(order_attrs, %{
        "monthly_date" => parse_date(monthly_date),
        "value" => taxi.plan.value,
        "status" => "paid",
        "type" => "money",
        "approved_at" => DateTime.utc_now()
      })

    %Order{}
    |> change_order(order_attrs)
    |> Repo.insert()
  end

  # def update_order(order, order_attrs) do
  #   order
  #   |> change_order(order_attrs)
  #   |> Repo.update()
  # end

  # def delete_order(%Order{} = order) do
  #   Repo.delete(order)
  # end

  def change_order(order \\ %Order{}, order_attrs \\ %{}) do
    Order.changeset(order, order_attrs)
  end
end
