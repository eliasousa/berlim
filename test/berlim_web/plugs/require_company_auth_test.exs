defmodule BerlimWeb.Plugs.RequireCompanyAuthTest do
  use BerlimWeb.ConnCase, async: true

  import BerlimWeb.Plugs.RequireCompanyAuth, only: [call: 2]
  import Berlim.Factory, only: [insert: 1]

  describe "user is authenticated as company" do
    setup %{conn: conn} do
      conn = assign(conn, :company, insert(:company))

      %{conn: conn}
    end

    test "user pass through when is authenticated as company", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status != 403
      assert conn.assigns.company
    end
  end

  describe "user is not authenticated as company" do
    setup %{conn: conn} do
      conn = assign(conn, :taxi, insert(:taxi))

      %{conn: conn}
    end

    test "send error message", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.status == 403
      assert conn.resp_body =~ "Você não pode acessar esse recurso"
      refute conn.assigns[:company]
    end
  end
end
