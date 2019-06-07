defmodule BerlimWeb.Plugs.RequireAdminAuthTest do
  use BerlimWeb.ConnCase, async: true

  import BerlimWeb.Plugs.RequireAdminAuth, only: [call: 2]
  import Berlim.Factory, only: [insert: 1]

  describe "user is not authenticated as admin" do
    setup %{conn: conn} do
      conn = assign(conn, :taxi, insert(:taxi))

      %{conn: conn}
    end

    test "send 401 response", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status == 403
      assert conn.resp_body == "{\"error\":\"Você não pode acessar esse recurso\"}"
      refute conn.assigns[:admin]
    end
  end

  describe "user is authenticated as admin" do
    setup %{conn: conn} do
      conn = assign(conn, :admin, insert(:admin))

      %{conn: conn}
    end

    test "user pass through when is authenticated as admin", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status != 403
      assert conn.assigns.admin
    end
  end
end
