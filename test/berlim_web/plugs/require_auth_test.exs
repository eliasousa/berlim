defmodule BerlimWeb.Plugs.RequireAuthTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  import BerlimWeb.Plugs.RequireAuth, only: [call: 2]
  import BerlimWeb.Helpers.PlugHelper, only: [setup_conn: 1]
  import Berlim.Factory, only: [insert: 1]

  describe "when user is not authenticated" do
    setup %{conn: conn} do
      setup_conn(conn)
    end

    test "redirects to Login /new and shows error message", %{conn: conn} do
      conn = call(conn, %{})

      assert get_flash(conn, :error) == "Você precisa estar logado para acessar essa página."
      assert redirected_to(conn, 302) == Routes.login_path(conn, :new)
      assert conn.halted
    end
  end

  describe "when user is authenticated" do
    setup %{conn: conn} do
      conn
      |> authenticate(insert(:taxi))
      |> setup_conn()
    end

    test "user pass through when is authenticated", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status != 302
    end
  end
end
