defmodule BerlimWeb.Plugs.RequireAdminAuth do
  @moduledoc """
  The require adming auth Plug.
  """

  import Plug.Conn
  import Phoenix.Controller

  alias BerlimWeb.Router.Helpers, as: Routes

  alias Berlim.{
    Repo,
    Accounts.Admin
  }

  def init(_params) do

  end

  def call(conn, _params) do
    user = conn.assigns[:user]

    if user && Repo.get!(Admin, user.id) do
      conn
    else
        conn
        |> put_flash(:error, "Você não tem permissão para acessar essa página!")
        |> redirect(to: Routes.login_path(conn, :index))
        |> halt()
    end
  end
end
