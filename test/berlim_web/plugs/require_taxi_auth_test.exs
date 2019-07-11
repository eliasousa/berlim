defmodule BerlimWeb.Plugs.RequireTaxiAuthTest do
  use BerlimWeb.ConnCase, async: true

  import BerlimWeb.Plugs.RequireTaxiAuth, only: [call: 2]
  import Berlim.Factory, only: [insert: 1]

  describe "user is authenticated as taxi" do
    setup %{conn: conn} do
      conn = assign(conn, :taxi, insert(:taxi))

      %{conn: conn}
    end

    test "user pass through when is authenticated as taxi", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status != 403
      assert conn.assigns.taxi
    end
  end

  describe "user is not authenticated as taxi" do
    setup %{conn: conn} do
      conn = assign(conn, :admin, insert(:admin))

      %{conn: conn}
    end

    test "send error message", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status == 403
      assert conn.resp_body =~ "Você não pode acessar esse recurso"
      refute conn.assigns[:taxi]
    end
  end
end
