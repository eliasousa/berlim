defmodule BerlimWeb.TaxiController do
  use BerlimWeb, :controller

  alias Berlim.{Accounts}

  def index(conn, _params) do
    taxis = Accounts.get_all_taxis()

    render conn, "index.html", taxis: taxis
  end

  def new(conn, _params) do
    changeset = Accounts.taxi_changeset()

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"taxi" => taxi}) do
    case Accounts.create_taxi(taxi) do
      {:ok, _taxi} ->
        conn
        |> put_flash(:info, "Taxi criado com sucesso!")
        |> redirect(to: taxi_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => taxi_id}) do
    taxi = Accounts.get_taxi_by_id(taxi_id)
    changeset = Accounts.taxi_changeset()

    render conn, "edit.html", taxi: taxi, changeset: changeset
  end
end
