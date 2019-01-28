defmodule BerlimWeb.Helpers.PlugHelper do
  @moduledoc """
  Module with methods to help plugs tests.
  """
  @endpoint BerlimWeb.Endpoint
  import Phoenix.ConnTest,
    only: [
      bypass_through: 3,
      get: 2
    ]

  def setup_conn(conn) do
    conn =
      conn
      |> bypass_through(BerlimWeb.Router, :browser)
      |> get("/")

    %{conn: conn}
  end
end
