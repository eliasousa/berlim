defmodule BerlimWeb.Plugs.RequireAdminAuth do
  @moduledoc """
  The require adming auth Plug.
  """

  import Plug.Conn

  import Phoenix.Controller,
    only: [
      put_flash: 3,
      redirect: 2
    ]

  alias BerlimWeb.Router.Helpers, as: Routes

  alias Berlim.{
    Repo,
    Accounts.Admin
  }

  def init(params), do: params

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    if user_id && Repo.get(Admin, user_id) do
      conn
    else
      conn
      |> put_flash(:error, "Você não tem permissão para acessar essa página!")
      |> redirect(to: Routes.home_path(conn, :index))
      |> halt()
    end
  end
end
