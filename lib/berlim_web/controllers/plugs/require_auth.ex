defmodule BerlimWeb.Plugs.RequireAuth do
  @moduledoc """
  The require user auth Plug
  """
  import Plug.Conn

  import Phoenix.Controller,
    only: [
      put_flash: 3,
      redirect: 2
    ]

  alias BerlimWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "Você precisa estar logado para acessar essa página.")
      |> redirect(to: Routes.login_path(conn, :new))
      |> halt()
    end
  end
end
