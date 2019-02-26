defmodule BerlimWeb.Helpers.AuthHelper do
  @moduledoc """
  Module with methods to help the authetication process on tests.
  """

  import Plug.Conn, only: [put_req_header: 3]
  alias Berlim.Guardian

  defmacro __using__(_) do
    quote do
      import BerlimWeb.Helpers.AuthHelper
    end
  end

  def authenticate(conn, user) do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{type: get_user_type(user)})

    conn = put_req_header(conn, "authorization", "Bearer #{jwt}")

    %{conn: conn}
  end

  defp get_user_type(user) do
    user.__struct__ |> Module.split() |> List.last()
  end
end
