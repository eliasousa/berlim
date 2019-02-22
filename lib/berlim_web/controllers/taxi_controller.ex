defmodule BerlimWeb.TaxiController do
  use BerlimWeb, :controller

  alias Berlim.InternalAccounts
  alias Berlim.InternalAccounts.Taxi

  action_fallback(BerlimWeb.FallbackController)

  def index(conn, _params) do
    taxis = InternalAccounts.list_taxis()
    render(conn, "index.json", taxis: taxis)
  end

  def create(conn, %{"taxi" => taxi_params}) do
    with {:ok, %Taxi{} = taxi} <- InternalAccounts.create_taxi(taxi_params) do
      conn
      |> put_status(:created)
      |> render("show.json", taxi: taxi)
    end
  end

  def show(conn, %{"id" => id}) do
    taxi = InternalAccounts.get_taxi!(id)
    render(conn, "show.json", taxi: taxi)
  end

  def update(conn, %{"id" => id, "taxi" => taxi_params}) do
    taxi = InternalAccounts.get_taxi!(id)

    with {:ok, %Taxi{} = taxi} <- InternalAccounts.update_taxi(taxi, taxi_params) do
      render(conn, "show.json", taxi: taxi)
    end
  end
end
