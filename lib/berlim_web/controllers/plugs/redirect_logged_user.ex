defmodule BerlimWeb.Plugs.RedirectLoggedUser do
  @moduledoc """
  The redirect logged in user Plug
  """
  import Phoenix.Controller, only: [redirect: 2]

  alias BerlimWeb.Router.Helpers, as: Routes

  def init(params), do: params

  def call(conn, _params) do
    cond do
      conn.assigns[:is_admin?] ->
        redirect(conn, to: Routes.admin_path(conn, :index))

      conn.assigns[:is_taxi?] ->
        redirect(conn, to: Routes.dashboard_path(conn, :index))

      true ->
        conn
    end
  end
end
