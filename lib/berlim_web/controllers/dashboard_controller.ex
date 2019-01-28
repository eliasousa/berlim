defmodule BerlimWeb.DashboardController do
  use BerlimWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
