defmodule BerlimWeb.Plugs.RequireTaxiAuth do
  @moduledoc """
  The require taxi auth Plug.
  """
  use BerlimWeb.Plugs.Helpers.RequireAuthHelper

  def init(params), do: params

  def call(conn, _params), do: check_user_auth(:taxi, conn)
end
