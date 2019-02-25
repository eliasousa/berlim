defmodule BerlimWeb.Plugs.Guardian.AuthErrorHandler do
  @moduledoc """
  Guardian auth error handler.
  """

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end
end
