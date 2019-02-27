defmodule BerlimWeb.Plugs.Guardian.AuthErrorHandler do
  @moduledoc """
  Guardian auth error handler.
  """

  import Plug.Conn
  use Phoenix.Controller

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(401)
    |> json(%{error: to_string(type)})
    |> halt()
  end
end
