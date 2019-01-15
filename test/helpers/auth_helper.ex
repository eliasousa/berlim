defmodule BerlimWeb.Helpers.AuthHelper do
  @moduledoc """
  Module with methods to help the authetication process on tests.
  """
  import Plug.Test, only: [init_test_session: 2]
  import Berlim.Factory

  defmacro __using__(_) do
    quote do
      import BerlimWeb.Helpers.AuthHelper
    end
  end

  def authenticate(conn, %{id: id} \\ insert(:admin)) do
    init_test_session(conn, user_id: id)
  end
end
