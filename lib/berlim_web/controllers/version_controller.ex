defmodule BerlimWeb.VersionController do
  use BerlimWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json", app_version: System.get_env("APP_VERSION"))
  end
end
