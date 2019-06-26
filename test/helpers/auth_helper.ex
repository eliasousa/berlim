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
    auth_user = String.downcase(get_user_type(user))

    %{conn: conn, "#{auth_user}": user}
  end

  def authenticate_with_token(conn) do
    %{conn: put_req_header(conn, "authorization", "Token token=dd8b755606431913f5a3d96c4f90d6c5")}
  end

  defp get_user_type(user) do
    user.__struct__ |> Module.split() |> List.last()
  end
end
