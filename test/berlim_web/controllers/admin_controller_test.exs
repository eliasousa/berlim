defmodule BerlimWeb.AdminControllerTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  @create_attrs params_for(:admin)
  @update_attrs %{name: "Lionel Ritchie"}
  @invalid_attrs %{name: nil, email: nil}

  describe "GET /index, when user is an admin" do
    setup [:authenticate_admin]

    test "lists all admins", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Admins"
    end
  end

  describe "GET /new, when user is an admin" do
    setup [:authenticate_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :new))
      assert html_response(conn, 200) =~ "Novo Admin"
    end
  end

  describe "POST /create, when user is an admin" do
    setup [:authenticate_admin]

    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :create), admin: @create_attrs)
      assert redirected_to(conn) == Routes.admin_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :create), admin: @invalid_attrs)
      assert html_response(conn, 200) =~ "Novo Admin"
    end
  end

  describe "GET /edit, when user is an admin" do
    setup [:create_admin, :authenticate_admin]

    test "renders form for editing chosen admin", %{conn: conn, admin: admin} do
      conn = get(conn, Routes.admin_path(conn, :edit, admin))
      assert html_response(conn, 200) =~ "Editar Admin"
    end
  end

  describe "PUT /update, when user is an admin" do
    setup [:create_admin, :authenticate_admin]

    test "redirects when data is valid", %{conn: conn, admin: admin} do
      conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @update_attrs)
      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.admin_path(conn, :edit, admin))
      assert html_response(conn, 200) =~ "Lionel Ritchie"
    end

    test "renders errors when data is invalid", %{conn: conn, admin: admin} do
      conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editar Admin"
    end
  end

  describe "DELETE /delete, when user is an admin" do
    setup [:create_admin, :authenticate_admin]

    test "deletes chosen admin", %{conn: conn, admin: admin} do
      conn = delete(conn, Routes.admin_path(conn, :delete, admin))
      assert redirected_to(conn) == Routes.admin_path(conn, :index)
    end
  end

  defp create_admin(_) do
    admin = insert(:admin)
    {:ok, admin: admin}
  end

  defp authenticate_admin(%{conn: conn}) do
    conn = authenticate(conn, insert(:admin))
    %{conn: conn}
  end
end
