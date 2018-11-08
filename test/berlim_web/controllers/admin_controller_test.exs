defmodule BerlimWeb.AdminControllerTest do
  use BerlimWeb.ConnCase

  alias Berlim.Accounts

  @create_attrs %{name: "John Doe", email: "johndoe@example.com", password: "1234abcd", active: true}
  @update_attrs %{name: "Lionel Ritchie"}
  @invalid_attrs %{name: nil, email: nil}

  def fixture(:admin) do
    {:ok, admin} = Accounts.create_admin(@create_attrs)
    admin
  end

  describe "index" do
    test "lists all admins", %{conn: conn} do
      conn = get conn, Routes.admin_path(conn, :index)
      assert html_response(conn, 200) =~ "Admins"
    end
  end

  describe "new admin" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.admin_path(conn, :new)
      assert html_response(conn, 200) =~ "Novo Admin"
    end
  end

  describe "create admin" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_path(conn, :create), admin: @create_attrs
      assert redirected_to(conn) == Routes.admin_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_path(conn, :create), admin: @invalid_attrs
      assert html_response(conn, 200) =~ "Novo Admin"
    end
  end

  describe "edit admin" do
    setup [:create_admin]

    test "renders form for editing chosen admin", %{conn: conn, admin: admin} do
      conn = get conn, Routes.admin_path(conn, :edit, admin)
      assert html_response(conn, 200) =~ "Editar Admin"
    end
  end

  describe "update admin" do
    setup [:create_admin]

    test "redirects when data is valid", %{conn: conn, admin: admin} do
      conn = put conn, Routes.admin_path(conn, :update, admin), admin: @update_attrs
      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get conn, Routes.admin_path(conn, :edit, admin)
      assert html_response(conn, 200) =~ "Lionel Ritchie"
    end

    test "renders errors when data is invalid", %{conn: conn, admin: admin} do
      conn = put conn, Routes.admin_path(conn, :update, admin), admin: @invalid_attrs
      assert html_response(conn, 200) =~ "Editar Admin"
    end
  end

  describe "delete admin" do
    setup [:create_admin]

    test "deletes chosen admin", %{conn: conn, admin: admin} do
      conn = delete conn, Routes.admin_path(conn, :delete, admin)
      assert redirected_to(conn) == Routes.admin_path(conn, :index)
    end
  end

  defp create_admin(_) do
    admin = fixture(:admin)
    {:ok, admin: admin}
  end
end
