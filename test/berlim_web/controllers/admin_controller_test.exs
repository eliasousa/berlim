defmodule BerlimWeb.AdminControllerTest do
  use BerlimWeb.ConnCase

  import Berlim.Factory
  alias Berlim.InternalAccounts.Admin

  @create_attrs params_for(:admin)
  @update_attrs %{name: "Lionel Ritchie"}
  @invalid_attrs %{name: nil, email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET /index" do
    test "lists all admins", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "POST /create" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :create), admin: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.admin_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "John Doe"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_path(conn, :create), admin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PUT /update" do
    setup [:create_admin]

    test "redirects when data is valid", %{conn: conn, admin: %Admin{id: id} = admin} do
      conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.admin_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "Lionel Ritchie"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, admin: admin} do
      conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "DELETE /delete" do
    setup [:create_admin]

    test "deletes chosen admin", %{conn: conn, admin: admin} do
      conn = delete(conn, Routes.admin_path(conn, :delete, admin))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.admin_path(conn, :show, admin))
      end)
    end
  end

  defp create_admin(_) do
    admin = insert(:admin)
    {:ok, admin: admin}
  end
end
