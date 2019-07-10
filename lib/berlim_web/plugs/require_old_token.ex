defmodule BerlimWeb.Plugs.RequireOldToken do
  @moduledoc """
  The require admin auth Plug.
  """

  import Plug.Conn,
    only: [
      get_req_header: 2,
      halt: 1,
      put_resp_content_type: 2,
      resp: 3
    ]

  def init(params), do: params

  def call(conn, _params) do
    case conn |> get_req_header("authorization") |> List.first() do
      "Token token=dd8b755606431913f5a3d96c4f90d6c5" -> conn
      _ -> error_return_and_halt(conn)
    end
  end

  defp error_return_and_halt(conn) do
    response = Poison.encode!(%{error: "Token inválido"})

    conn
    |> put_resp_content_type("application/json")
    |> resp(403, response)
    |> halt()
  end
end
