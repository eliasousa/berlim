defmodule BerlimWeb.TaxiControllerTest do
  use BerlimWeb.ConnCase
  use Plug.Test

  import Berlim.Factory

  @valid_attrs params_for(:taxi)
  @update_attrs %{cpf: "12345678910"}
  @invalid_attrs %{cpf: nil, email: nil}

  describe "GET /index, when user is an admin" do
    setup [:assign_admin_on_conn]

    test "list all taxis", %{conn: conn} do
      conn =
        conn
        |> get(Routes.taxi_path(conn, :index))

      assert html_response(conn, 200) =~ "Táxis"
    end
  end

  describe "GET /index, when user is not an admin" do
    test "redirects to Login /index and shows error message", %{conn: conn} do
      conn =
        conn
        |> get(Routes.taxi_path(conn, :index))

      assert redirected_to(conn, 302) == Routes.login_path(conn, :index)
      assert get_flash(conn, :error) == "Você não tem permissão para acessar essa página!"
    end
  end

  describe "GET /new, when user is an admin" do
    setup [:assign_admin_on_conn]

    test "renders form", %{conn: conn} do
      conn =
        conn
        |> get(Routes.taxi_path(conn, :new))

      assert html_response(conn, 200) =~ "Novo Táxi"
    end
  end

  describe "GET /new, when user is not an admin" do
    test "redirects to Login /index and shows error message", %{conn: conn} do
      conn =
        conn
        |> get(Routes.taxi_path(conn, :new))

      assert redirected_to(conn, 302) == Routes.login_path(conn, :index)
      assert get_flash(conn, :error) == "Você não tem permissão para acessar essa página!"
    end
  end

  describe "POST /create, when user is an admin" do
    setup [:assign_admin_on_conn]

    test "redirects to index when data is valid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.taxi_path(conn, :create), taxi: @valid_attrs)

      assert redirected_to(conn) == Routes.taxi_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.taxi_path(conn, :create), taxi: @invalid_attrs)

      assert html_response(conn, 200) =~ "Oops, algo errado aconteceu!"
    end
  end

  describe "POST /create, when user is not an admin" do
    test "redirects to Login /index and shows error message", %{conn: conn} do
      conn =
        conn
        |> post(Routes.taxi_path(conn, :create), taxi: @valid_attrs)

      assert redirected_to(conn, 302) == Routes.login_path(conn, :index)
      assert get_flash(conn, :error) == "Você não tem permissão para acessar essa página!"
    end
  end

  describe "GET /edit, when user is an admin" do
    setup [:assign_admin_on_conn, :insert_taxi]

    test "renders form for editing chosen taxi", %{conn: conn, taxi: taxi} do
      conn =
        conn
        |> get(Routes.taxi_path(conn, :edit, taxi))

      assert conn.assigns.taxi == taxi
      assert html_response(conn, 200) =~ "Editar Táxi"
    end
  end

  describe "GET /edit, when user is not an admin" do
    setup [:insert_taxi]

    test "redirects to Login /index and shows error message", %{conn: conn, taxi: taxi} do
      conn =
        conn
        |> get(Routes.taxi_path(conn, :edit, taxi))

      assert redirected_to(conn, 302) == Routes.login_path(conn, :index)
      assert get_flash(conn, :error) == "Você não tem permissão para acessar essa página!"
    end
  end

  describe "PUT /update, when user is an admin" do
    setup [:assign_admin_on_conn, :insert_taxi]

    test "redirects when data is valid", %{conn: conn, taxi: taxi} do
      conn =
        conn
        |> put(Routes.taxi_path(conn, :update, taxi), taxi: @update_attrs)

      assert redirected_to(conn) == Routes.taxi_path(conn, :index)
      assert get_flash(conn, :info) == "Táxi atualizado com sucesso."
    end

    test "renders errors when data is invalid", %{conn: conn, taxi: taxi} do
      conn =
        conn
        |> put(Routes.taxi_path(conn, :update, taxi), taxi: @invalid_attrs)

      assert html_response(conn, 200) =~ "Oops, algo errado aconteceu!"
    end
  end

  describe "PUT /update, when user is not an admin" do
    setup [:insert_taxi]

    test "redirects to Login /index and shows error message", %{conn: conn, taxi: taxi} do
      conn =
        conn
        |> put(Routes.taxi_path(conn, :update, taxi), taxi: @update_attrs)

      assert redirected_to(conn, 302) == Routes.login_path(conn, :index)
      assert get_flash(conn, :error) == "Você não tem permissão para acessar essa página!"
    end

  end

  defp insert_taxi(_) do
    %{taxi: insert(:taxi)}
  end

  defp assign_admin_on_conn(_) do
    admin = insert(:admin)

    conn =
      build_conn()
      |> assign(:user, admin)

    {:ok, conn: conn}
  end
end