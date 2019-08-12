defmodule BerlimWeb.Plugs.AssignUserTest do
  use BerlimWeb.ConnCase, async: true

  import BerlimWeb.Plugs.AssignUser, only: [call: 2]
  import Berlim.Factory, only: [insert: 1]

  alias BerlimWeb.Guardian

  describe "user is authenticated as taxi" do
    setup %{conn: conn} do
      conn = sign_in_user(conn, :taxi)

      %{conn: conn}
    end

    test "taxi is assigned on conn", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.assigns.taxi
    end
  end

  describe "user is authenticated as admin" do
    setup %{conn: conn} do
      conn = sign_in_user(conn, :admin)

      %{conn: conn}
    end

    test "admin is assigned on conn", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.assigns.admin
    end
  end

  describe "user is authenticated as company" do
    setup %{conn: conn} do
      conn = sign_in_user(conn, :company)

      %{conn: conn}
    end

    test "company is assigned on conn", %{conn: conn} do
      conn = call(conn, %{})

      assert conn.assigns.company
    end
  end

  defp sign_in_user(conn, user) do
    Guardian.Plug.sign_in(conn, insert(user))
  end
end
