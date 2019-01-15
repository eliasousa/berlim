defmodule BerlimWeb.Plugs.RequireAdminAuthTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  import BerlimWeb.Plugs.RequireAdminAuth, only: [call: 2]
  import BerlimWeb.Helpers.PlugHelper, only: [setup_conn: 1]

  describe "user is not authenticated as admin" do
    setup %{conn: conn} do
      setup_conn(conn)
    end

    test "redirects to Home /index and shows error message", %{conn: conn} do
      conn = call(conn, %{})

      assert redirected_to(conn, 302) == Routes.home_path(conn, :index)
      assert get_flash(conn, :error) == "Você não tem permissão para acessar essa página!"
    end
  end

  describe "user is authenticated as admin" do
    setup %{conn: conn} do
      conn = authenticate(conn)

      %{conn: conn}
    end

    test "user pass through when is authenticated as admin", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status != 302
    end
  end
end
