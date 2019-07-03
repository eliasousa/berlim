defmodule BerlimWeb.Old.TaxiController do
  use BerlimWeb, :controller

  alias Bcrypt
  alias Berlim.{InternalAccounts.Taxi, Repo}

  def show(conn, %{"vt" => smtt, "password" => password}) do
    case Repo.get_by(Taxi, smtt: smtt) do
      taxi = %Taxi{} ->
        if Bcrypt.verify_pass(password, taxi.encrypted_password) do
          json(conn, [%{id: taxi.id}])
        else
          json(conn, false)
        end

      nil ->
        json(conn, false)
    end
  end

  def show(conn, _params) do
    json(conn, false)
  end
end
