defmodule BerlimWeb.Plugs.RequireOldTokenTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import BerlimWeb.Plugs.RequireOldToken, only: [call: 2]

  describe "request with correct token" do
    setup %{conn: conn} do
      authenticate_with_token(conn)
    end

    test "permit request", %{conn: conn} do
      conn = call(conn, %{})
      assert conn.status != 403
    end
  end

  describe "request without correct token" do
    test "send 403 response", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status == 403
      assert conn.resp_body == "{\"error\":\"Token inválido\"}"
    end
  end
end
