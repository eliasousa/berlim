defmodule BerlimWeb.Plugs.RequireAdminAuth do
  @moduledoc """
  The require admin auth Plug.
  """
  use BerlimWeb.Plugs.Helpers.RequireAuthHelper

  def init(params), do: params

  def call(conn, _params), do: check_user_auth(:admin, conn)
end
