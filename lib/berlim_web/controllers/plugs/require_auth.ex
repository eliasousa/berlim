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

  alias Berlim.{
    Repo,
    InternalAccounts.Admin,
    InternalAccounts.Taxi
  }

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user_id && Repo.get(Admin, user_id) ->
        conn

      user_id && Repo.get(Taxi, user_id) ->
        conn

      true ->
        conn
        |> put_flash(:error, "Você precisa estar logado para acessar essa página.")
        |> redirect(to: Routes.login_path(conn, :new))
        |> halt()
    end
  end
end
