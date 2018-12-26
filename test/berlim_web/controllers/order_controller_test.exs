defmodule BerlimWeb.OrderControllerTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  alias Berlim.Repo

  import Berlim.Factory

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
      conn = get(conn, Routes.order_path(conn, :new))
      assert html_response(conn, 200) =~ "Novo Pagamento"
    end
  end

  describe "POST /create, when user is an admin" do
    setup [:authenticate_admin]

    test "redirects to index when data is valid", %{conn: conn} do
      taxi = insert(:taxi) |> Repo.preload(:plan)
      create_attrs = %{"monthly_date" => "25/10/2018", "taxi_id" => taxi.id}

      conn = post(conn, Routes.order_path(conn, :create), order: create_attrs)
      assert redirected_to(conn) == Routes.order_path(conn, :index)
    end

    test "renders errors when monthly_date is invalid", %{conn: conn} do
      taxi = insert(:taxi) |> Repo.preload(:plan)
      invalid_attrs = %{"monthly_date" => "", "taxi_id" => taxi.id}

      conn = post(conn, Routes.order_path(conn, :create), order: invalid_attrs)
      assert html_response(conn, 200) =~ "Novo Pagamento"
    end
  end

  # describe "GET /edit, when user is an admin" do
  #   setup [:create_admin, :authenticate_admin]

  #   test "renders form for editing chosen admin", %{conn: conn, admin: admin} do
  #     conn = get(conn, Routes.admin_path(conn, :edit, admin))
  #     assert html_response(conn, 200) =~ "Editar Admin"
  #   end
  # end

  # describe "PUT /update, when user is an admin" do
  #   setup [:create_admin, :authenticate_admin]

  #   test "redirects when data is valid", %{conn: conn, admin: admin} do
  #     conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @update_attrs)
  #     assert redirected_to(conn) == Routes.admin_path(conn, :index)

  #     conn = get(conn, Routes.admin_path(conn, :edit, admin))
  #     assert html_response(conn, 200) =~ "Lionel Ritchie"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, admin: admin} do
  #     conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Editar Admin"
  #   end
  # end

  # describe "DELETE /delete, when user is an admin" do
  #   setup [:create_admin, :authenticate_admin]

  #   test "deletes chosen admin", %{conn: conn, admin: admin} do
  #     conn = delete(conn, Routes.admin_path(conn, :delete, admin))
  #     assert redirected_to(conn) == Routes.admin_path(conn, :index)
  #   end
  # end

  # defp create_admin(_) do
  #   admin = insert(:admin)
  #   {:ok, admin: admin}
  # end

  defp authenticate_admin(%{conn: conn}) do
    conn = authenticate(conn)
    %{conn: conn}
  end
end
