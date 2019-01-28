defmodule BerlimWeb.Plugs.SetUserTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  import BerlimWeb.Plugs.SetUser, only: [call: 2]
  import BerlimWeb.Helpers.PlugHelper, only: [setup_conn: 1]
  import Berlim.Factory, only: [insert: 1]

  describe "when user is not authenticated" do
    setup %{conn: conn} do
      setup_conn(conn)
    end

    test "conn.assigns.current_user is nil", %{conn: conn} do
      conn = call(conn, %{})

      refute conn.assigns.current_user
    end
  end

  describe "when user is authenticated as admin" do
    setup %{conn: conn} do
      conn
      |> authenticate(insert(:admin))
      |> setup_conn()
    end

    test "set the user on conn.assigns.current_user as admin", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.assigns.current_user
      assert conn.assigns.is_admin? == true
    end
  end

  describe "when user is authenticated as taxi" do
    setup %{conn: conn} do
      conn
      |> authenticate(insert(:taxi))
      |> setup_conn()
    end

    test "set the user on conn.assigns.current_user as taxi", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.assigns.current_user
      assert conn.assigns.is_taxi? == true
    end
  end
end
