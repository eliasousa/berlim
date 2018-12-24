defmodule Berlim.Sales do
  @moduledoc """
  The Sales context.
  """
  alias Berlim.{
    Repo,
    Sales.Plan,
    Sales.Order
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

  def list_orders, do: Repo.all(Order)

  def get_order!(id), do: Repo.get!(Order, id)

  def create_order(order_attrs) do
    %Order{}
    |> change_order(order_attrs)
    |> Repo.insert()
  end

  def update_order(order, order_attrs) do
    order
    |> change_order(order_attrs)
    |> Repo.update()
  end

  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  def change_order(order \\ %Order{}, order_attrs \\ %{}) do
    Order.changeset(order, order_attrs)
  end
end
