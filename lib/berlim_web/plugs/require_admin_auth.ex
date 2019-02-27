defmodule BerlimWeb.Plugs.RequireAdminAuth do
  @moduledoc """
  The require admin auth Plug.
  """

  import Plug.Conn

  use Phoenix.Controller

  alias Berlim.{Guardian, InternalAccounts.Admin}

  def init(params), do: params

  def call(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      %Admin{} ->
        conn

      _ ->
        conn
        |> put_status(401)
        |> json(%{error: "Você não pode acessar esse recurso"})
        |> halt()
    end
  end
end
