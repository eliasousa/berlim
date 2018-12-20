defmodule BerlimWeb.TaxiControllerTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  @update_attrs %{cpf: "12345678910"}
  @invalid_attrs %{cpf: nil, email: nil}

  describe "GET /index, when user is an admin" do
    setup [:authenticate_admin]

    test "list all taxis", %{conn: conn} do
      conn = get(conn, Routes.taxi_path(conn, :index))

      assert html_response(conn, 200) =~ "Táxis"
    end
  end

  describe "GET /new, when user is an admin" do
    setup [:authenticate_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.taxi_path(conn, :new))

      assert html_response(conn, 200) =~ "Novo Táxi"
    end
  end

  describe "POST /create, when user is an admin" do
    setup [:authenticate_admin]

    test "redirects to index when data is valid", %{conn: conn} do
      valid_attrs = params_for(:taxi, plan: insert(:plan))

      conn = post(conn, Routes.taxi_path(conn, :create), taxi: valid_attrs)

      assert redirected_to(conn) == Routes.taxi_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.taxi_path(conn, :create), taxi: @invalid_attrs)

      assert html_response(conn, 200) =~ "Oops, algo errado aconteceu!"
    end
  end

  describe "GET /edit, when user is an admin" do
    setup [:authenticate_admin, :insert_taxi]

    test "renders form for editing chosen taxi", %{conn: conn, taxi: taxi} do
      conn = get(conn, Routes.taxi_path(conn, :edit, taxi))

      assert conn.assigns.taxi.id == taxi.id
      assert conn.assigns.taxi.cpf == taxi.cpf
      assert html_response(conn, 200) =~ "Editar Táxi"
    end
  end

  describe "PUT /update, when user is an admin" do
    setup [:authenticate_admin, :insert_taxi]

    test "redirects when data is valid", %{conn: conn, taxi: taxi} do
      conn = put(conn, Routes.taxi_path(conn, :update, taxi), taxi: @update_attrs)

      assert redirected_to(conn) == Routes.taxi_path(conn, :index)
      assert get_flash(conn, :info) == "Táxi atualizado com sucesso."
    end

    test "renders errors when data is invalid", %{conn: conn, taxi: taxi} do
      conn = put(conn, Routes.taxi_path(conn, :update, taxi), taxi: @invalid_attrs)

      assert html_response(conn, 200) =~ "Oops, algo errado aconteceu!"
    end
  end

  defp insert_taxi(_) do
    %{taxi: insert(:taxi)}
  end

  defp authenticate_admin(%{conn: conn}) do
    conn = authenticate(conn)
    %{conn: conn}
  end
end
