defmodule BerlimWeb.TaxiController do
  use BerlimWeb, :controller

  alias Berlim.InternalAccounts

  def index(conn, params) do
    page = InternalAccounts.list_taxis(params)

    render(conn, "index.html", taxis: page.entries, page: page)
  end

  def new(conn, _params) do
    changeset = InternalAccounts.change_taxi()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"taxi" => taxi_params}) do
    case InternalAccounts.create_taxi(taxi_params) do
      {:ok, _taxi} ->
        conn
        |> put_flash(:info, "Táxi criado com sucesso.")
        |> redirect(to: Routes.taxi_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => taxi_id}) do
    taxi = InternalAccounts.get_taxi!(taxi_id)
    changeset = InternalAccounts.change_taxi(taxi)

    render(conn, "edit.html", taxi: taxi, changeset: changeset)
  end

  def update(conn, %{"id" => taxi_id, "taxi" => taxi_params}) do
    taxi = InternalAccounts.get_taxi!(taxi_id)

    case InternalAccounts.update_taxi(taxi, taxi_params) do
      {:ok, _taxi} ->
        conn
        |> put_flash(:info, "Táxi atualizado com sucesso.")
        |> redirect(to: Routes.taxi_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", taxi: taxi, changeset: changeset)
    end
  end
end
