defmodule BerlimWeb.Plugs.RequireOldToken do
  @moduledoc """
  The require admin auth Plug.
  """

  import Plug.Conn, only: [put_status: 2, get_req_header: 2]
  use Phoenix.Controller

  def init(params), do: params

  def call(conn, _params) do
    case conn |> get_req_header("authorization") |> List.first() do
      "Token token=dd8b755606431913f5a3d96c4f90d6c5" -> conn
      _ -> error_return_and_halt(conn)
    end
  end

  defp error_return_and_halt(conn) do
    conn
    |> put_status(403)
    |> json(%{error: "Token inválido"})
    |> halt()
  end
end
