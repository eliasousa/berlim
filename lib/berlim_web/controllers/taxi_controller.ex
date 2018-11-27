defmodule BerlimWeb.TaxiController do
  use BerlimWeb, :controller

  alias Berlim.Accounts

  plug BerlimWeb.Plugs.RequireAdminAuth

  def index(conn, _params) do
    taxis = Accounts.list_taxis()

    render conn, "index.html", taxis: taxis
  end

  def new(conn, _params) do
    changeset = Accounts.taxi_change()

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"taxi" => taxi_params}) do
    case Accounts.create_taxi(taxi_params) do
      {:ok, _taxi} ->
        conn
        |> put_flash(:info, "Táxi criado com sucesso.")
        |> redirect(to: Routes.taxi_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => taxi_id}) do
    taxi = Accounts.get_taxi!(taxi_id)
    changeset = Accounts.taxi_change(taxi)

    render conn, "edit.html", taxi: taxi, changeset: changeset
  end

  def update(conn, %{"id" => taxi_id, "taxi" => taxi_params}) do
    taxi = Accounts.get_taxi!(taxi_id)
    case Accounts.update_taxi(taxi, taxi_params) do
      {:ok, _taxi} ->
        conn
        |> put_flash(:info, "Táxi atualizado com sucesso.")
        |> redirect(to: Routes.taxi_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", taxi: taxi, changeset: changeset)
    end
  end
end
