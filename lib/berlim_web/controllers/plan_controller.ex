defmodule BerlimWeb.PlanController do
  use BerlimWeb, :controller

  alias Berlim.Sales
  alias Berlim.Sales.Plan

  def index(conn, _params) do
    plans = Sales.list_plans()
    render(conn, "index.html", plans: plans)
  end

  def new(conn, _params) do
    changeset = Sales.change_plan(%Plan{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"plan" => plan_params}) do
    case Sales.create_plan(plan_params) do
      {:ok, _plan} ->
        conn
        |> put_flash(:info, "Plano adicionado com  sucesso.")
        |> redirect(to: Routes.plan_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    plan = Sales.get_plan!(id)
    changeset = Sales.change_plan(plan)
    render(conn, "edit.html", plan: plan, changeset: changeset)
  end

  def update(conn, %{"id" => id, "plan" => plan_params}) do
    plan = Sales.get_plan!(id)

    case Sales.update_plan(plan, plan_params) do
      {:ok, _plan} ->
        conn
        |> put_flash(:info, "Plano atualizado com sucesso.")
        |> redirect(to: Routes.plan_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", plan: plan, changeset: changeset)
    end
  end
end
