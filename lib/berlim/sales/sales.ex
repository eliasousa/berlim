defmodule Berlim.Sales do
  @moduledoc """
  The Sales context.
  """
  alias Berlim.{
    Repo,
    Sales.Plan
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
end
