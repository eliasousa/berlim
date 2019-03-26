defmodule BerlimWeb.Plugs.RequireCompanyAuth do
  @moduledoc """
  The require company auth Plug.
  """
  use BerlimWeb.Plugs.Helpers.RequireAuthHelper

  def init(params), do: params

  def call(conn, _params), do: check_user_auth(:company, conn)
end
