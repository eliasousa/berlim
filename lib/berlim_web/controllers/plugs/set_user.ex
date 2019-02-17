defmodule BerlimWeb.Plugs.SetUser do
  @moduledoc """
  The set user Plug.
  """
  import Plug.Conn

  alias Berlim.{
    Repo,
    InternalAccounts.Admin,
    InternalAccounts.Taxi
  }

  def init(params), do: params

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      admin = user_id && Repo.get(Admin, user_id) ->
        conn
        |> assign(:current_user, admin)
        |> assign(:is_admin?, true)

      taxi = user_id && Repo.get(Taxi, user_id) ->
        conn
        |> assign(:current_user, taxi)
        |> assign(:is_taxi?, true)

      true ->
        conn
        |> assign(:current_user, nil)
    end
  end
end
