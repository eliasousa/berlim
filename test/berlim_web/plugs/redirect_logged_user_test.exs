defmodule BerlimWeb.Plugs.RedirectLoggedUserTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  import BerlimWeb.Plugs.RedirectLoggedUser, only: [call: 2]
  import BerlimWeb.Helpers.PlugHelper, only: [setup_conn: 1]
  import Berlim.Factory, only: [insert: 1]

  describe "when user is authenticated as admin" do
    setup %{conn: conn} do
      conn
      |> authenticate()
      |> setup_conn()
    end

    test "redirects to Admin /index", %{conn: conn} do
      conn = call(conn, %{})

      assert redirected_to(conn) == Routes.admin_path(conn, :index)
    end
  end

  describe "when user is authenticated as taxi" do
    setup %{conn: conn} do
      conn
      |> authenticate(insert(:taxi))
      |> setup_conn()
    end

    test "redirects to Dashboard /index", %{conn: conn} do
      conn = call(conn, %{})

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    end
  end

  describe "when user is not authenticated" do
    setup %{conn: conn} do
      setup_conn(conn)
    end

    test "the user is not redirected", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status != 302
    end
  end
end
