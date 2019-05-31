defmodule BerlimWeb.Plugs.RequireTaxiAuthTest do
  use BerlimWeb.ConnCase, async: true

  import BerlimWeb.Plugs.RequireTaxiAuth, only: [call: 2]
  import Berlim.Factory, only: [insert: 1]

  alias Berlim.Guardian

  describe "user is authenticated as taxi" do
    setup %{conn: conn} do
      conn = Guardian.Plug.sign_in(conn, insert(:taxi))

      %{conn: conn}
    end

    test "user pass through when is authenticated as taxi", %{conn: conn} do
      conn = call(conn, %{})
      assert conn.status != 403
    end
  end

  describe "user is not authenticated as taxi" do
    setup %{conn: conn} do
      conn = Guardian.Plug.sign_in(conn, insert(:admin))

      %{conn: conn}
    end

    test "send error message", %{conn: conn} do
      conn = call(conn, %{})
      assert conn.status == 403
      assert conn.resp_body =~ "Você não pode acessar esse recurso"
    end
  end
end
