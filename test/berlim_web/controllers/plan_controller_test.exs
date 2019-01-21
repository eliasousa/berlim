defmodule BerlimWeb.PlanControllerTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  @create_attrs params_for(:plan)
  @update_attrs %{name: "Especial", value: 150}
  @invalid_attrs %{name: nil, value: nil}

  describe "GET /index, when user is an admin" do
    setup [:authenticate_admin]

    test "lists all plans", %{conn: conn} do
      conn = get(conn, Routes.plan_path(conn, :index))
      assert html_response(conn, 200) =~ "Planos"
    end
  end

  describe "GET /new, when user is an admin" do
    setup [:authenticate_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.plan_path(conn, :new))
      assert html_response(conn, 200) =~ "Novo Plano"
    end
  end

  describe "POST /create, when user is an admin" do
    setup [:authenticate_admin]

    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.plan_path(conn, :create), plan: @create_attrs)
      assert redirected_to(conn) == Routes.plan_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.plan_path(conn, :create), plan: @invalid_attrs)
      assert html_response(conn, 200) =~ "Novo Plano"
    end
  end

  describe "GET /edit, when user is an admin" do
    setup [:create_plan, :authenticate_admin]

    test "renders form for editing chosen plan", %{conn: conn, plan: plan} do
      conn = get(conn, Routes.plan_path(conn, :edit, plan))
      assert html_response(conn, 200) =~ "Editar Plano"
    end
  end

  describe "PUT /update, when user is an admin" do
    setup [:create_plan, :authenticate_admin]

    test "redirects when data is valid", %{conn: conn, plan: plan} do
      conn = put(conn, Routes.plan_path(conn, :update, plan), plan: @update_attrs)
      assert redirected_to(conn) == Routes.plan_path(conn, :index)

      conn = get(conn, Routes.plan_path(conn, :edit, plan))
      assert html_response(conn, 200) =~ "Especial"
    end

    test "renders errors when data is invalid", %{conn: conn, plan: plan} do
      conn = put(conn, Routes.plan_path(conn, :update, plan), plan: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editar Plano"
    end
  end

  defp create_plan(_) do
    plan = insert(:plan)
    {:ok, plan: plan}
  end

  defp authenticate_admin(%{conn: conn}) do
    conn = authenticate(conn, insert(:admin))
    %{conn: conn}
  end
end
