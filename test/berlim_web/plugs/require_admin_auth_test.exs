defmodule BerlimWeb.Plugs.RequireAdminAuthTest do
  use BerlimWeb.ConnCase

  import BerlimWeb.Plugs.RequireAdminAuth, only: [call: 2]
  import Berlim.Factory, only: [insert: 1]
  alias Berlim.Guardian

  describe "user is not authenticated as admin" do
    setup %{conn: conn} do
      conn = Guardian.Plug.sign_in(conn, insert(:taxi))

      {:ok, conn: conn}
    end

    test "send 401 response", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status == 401
      assert conn.resp_body == "{\"error\":\"Você não pode acessar esse recurso\"}"
    end
  end

  describe "user is authenticated as admin" do
    setup %{conn: conn} do
      conn = Guardian.Plug.sign_in(conn, insert(:admin))

      {:ok, conn: conn}
    end

    test "user pass through when is authenticated as admin", %{conn: conn} do
      conn = call(conn, %{})
      assert conn.status != 401
    end
  end
end
