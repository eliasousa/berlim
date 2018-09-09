defmodule Berlim.PageController do
  use Berlim.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
