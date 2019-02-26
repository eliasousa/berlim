defmodule BerlimWeb.Plugs.RequireAdminAuth do
  @moduledoc """
  The require admin auth Plug.
  """

  import Plug.Conn

  use Phoenix.Controller

  alias Berlim.Guardian

  def init(params), do: params

  def call(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    if is_admin?(user) do
      conn
    else
      conn
      |> put_status(401)
      |> json(%{error: "Você não pode acessar esse recurso"})
      |> halt()
    end
  end

  defp is_admin?(user) do
    user.__struct__ |> Module.split() |> List.last() == "Admin"
  end
end
