defmodule BerlimWeb.Plugs.AssignUser do
  @moduledoc """
  The assign user Plug.
  """
  import Plug.Conn, only: [put_status: 2]

  use Phoenix.Controller

  alias Berlim.Guardian

  def init(params), do: params

  def call(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    user_type =
      user.__struct__
      |> Module.split()
      |> List.last()
      |> String.downcase()
      |> String.to_existing_atom()

    assign(conn, user_type, user)
  end
end
