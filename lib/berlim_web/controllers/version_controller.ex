defmodule BerlimWeb.VersionController do
  use BerlimWeb, :controller

  def index(conn, _params) do
    json(conn, %{app_version: 1})
  end
end
