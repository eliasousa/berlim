defmodule BerlimWeb.Plugs.RequireAdminAuth do
  @moduledoc """
  The require admin auth Plug.
  """

  import Plug.Conn
  alias Berlim.Guardian

  def init(params), do: params

  def call(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    if user.__struct__ |> Module.split() |> List.last() == "Admin" do
      conn
    else
      body = Jason.encode!(%{error: "Você não pode acessar esse resource"})
      send_resp(conn, 401, body)
    end
  end
end
