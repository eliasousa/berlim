defmodule BerlimWeb.Plugs.RequireTaxiAuth do
  @moduledoc """
  The require taxi auth Plug.
  """

  import Plug.Conn, only: [put_status: 2]

  use Phoenix.Controller

  def init(params), do: params

  def call(conn, _params) do
    if conn.assigns[:taxi] do
      conn
    else
      conn
      |> put_status(403)
      |> json(%{error: "Você não pode acessar esse recurso"})
      |> halt()
    end
  end
end
