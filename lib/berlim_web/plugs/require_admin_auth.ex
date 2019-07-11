defmodule BerlimWeb.Plugs.RequireAdminAuth do
  @moduledoc """
  The require admin auth Plug.
  """
  import Plug.Conn,
    only: [
      halt: 1,
      put_resp_content_type: 2,
      resp: 3
    ]

  def init(params), do: params

  def call(conn, _params) do
    if conn.assigns[:admin] do
      conn
    else
      response = Jason.encode!(%{error: "Você não pode acessar esse recurso"})

      conn
      |> put_resp_content_type("application/json")
      |> resp(403, response)
      |> halt()
    end
  end
end
