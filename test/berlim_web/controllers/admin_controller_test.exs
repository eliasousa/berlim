defmodule BerlimWeb.AdminControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  alias Berlim.InternalAccounts
  alias Berlim.InternalAccounts.Admin
  alias BerlimWeb.AdminView

  @create_attrs params_for(:admin, %{password: "1234abcd"})
  @update_attrs %{name: "Lionel Ritchie"}
  @invalid_attrs %{name: nil, email: nil}

  describe "GET /index, when user is an admin" do
    setup [:authenticate_admin]

    test "lists all admins", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))
      assert is_list(json_response(conn, 200)["data"])
    end
  end

  describe "GET /index, when user is not an admin" do
    setup [:authenticate_taxi]

    test "renders unauthorized", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "GET /show, when user is an admin" do
    setup [:create_admin, :authenticate_admin]

    test "renders admin", %{conn: conn, admin: admin} do
      conn = get(conn, Routes.admin_path(conn, :show, admin))
      assert json_response(conn, 200) == render_json(AdminView, "show.json", %{admin: admin})
    end
  end

  describe "GET /show, when user is not an admin" do
    setup [:create_admin, :authenticate_taxi]

    test "renders unauthorized", %{conn: conn, admin: admin} do
      conn = get(conn, Routes.admin_path(conn, :show, admin))
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "POST /create, when user is an admin" do
    setup [:authenticate_admin]

    test "renders admin show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :create), admin: @create_attrs)
      admin = InternalAccounts.get_admin!(json_response(conn, 201)["data"]["id"])

      assert json_response(conn, 201) == render_json(AdminView, "show.json", %{admin: admin})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :create), admin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "POST /create, when user is not an admin" do
    setup [:authenticate_taxi]

    test "renders unauthorized", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :create), admin: @create_attrs)
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "PUT /update, when user is an admin" do
    setup [:create_admin, :authenticate_admin]

    test "renders admin show when data is valid", %{conn: conn, admin: %Admin{id: id} = admin} do
      conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @update_attrs)
      admin = InternalAccounts.get_admin!(id)

      assert json_response(conn, 200) == render_json(AdminView, "show.json", %{admin: admin})
      assert json_response(conn, 200)["data"]["name"] == "Lionel Ritchie"
    end

    test "renders errors when data is invalid", %{conn: conn, admin: admin} do
      conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PUT /update, when user is not an admin" do
    setup [:create_admin, :authenticate_taxi]

    test "renders unauthorized", %{conn: conn, admin: admin} do
      conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @update_attrs)
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "DELETE /delete, when user is an admin" do
    setup [:create_admin, :authenticate_admin]

    test "deletes chosen admin", %{conn: conn, admin: admin} do
      conn = delete(conn, Routes.admin_path(conn, :delete, admin))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.admin_path(conn, :show, admin))
      end)
    end
  end

  describe "DELETE /delete, when user is not an admin" do
    setup [:create_admin, :authenticate_taxi]

    test "renders unauthorized", %{conn: conn, admin: admin} do
      conn = delete(conn, Routes.admin_path(conn, :delete, admin))
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  defp create_admin(_) do
    %{admin: insert(:admin)}
  end

  defp authenticate_admin(%{conn: conn}) do
    authenticate(conn, insert(:admin))
  end

  defp authenticate_taxi(%{conn: conn}) do
    authenticate(conn, insert(:taxi))
  end
end
