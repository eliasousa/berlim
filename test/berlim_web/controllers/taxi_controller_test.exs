defmodule BerlimWeb.TaxiControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  alias Berlim.InternalAccounts
  alias Berlim.InternalAccounts.Taxi
  alias BerlimWeb.TaxiView

  @create_attrs params_for(:taxi)
  @update_attrs %{cpf: "12345678910"}
  @invalid_attrs %{cpf: nil, email: nil}

  describe "GET /index, when user is an admin" do
    setup [:authenticate_admin]

    test "list all taxis", %{conn: conn} do
      conn = get(conn, taxi_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "GET /index, when user is not an admin" do
    setup [:authenticate_taxi]

    test "renders unauthorized", %{conn: conn} do
      conn = get(conn, taxi_path(conn, :index))
      assert json_response(conn, 401)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "GET /show, when user is an admin" do
    setup [:create_taxi, :authenticate_admin]

    test "renders taxi", %{conn: conn, taxi: taxi} do
      conn = get(conn, taxi_path(conn, :show, taxi))
      assert json_response(conn, 200) == render_json(TaxiView, "show.json", %{taxi: taxi})
    end
  end

  describe "GET /show, when user is not an admin" do
    setup [:create_taxi, :authenticate_taxi]

    test "renders unauthorized", %{conn: conn, taxi: taxi} do
      conn = get(conn, taxi_path(conn, :show, taxi))
      assert json_response(conn, 401)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "POST /create, when user is an admin" do
    setup [:authenticate_admin]

    test "renders taxi show when data is valid", %{conn: conn} do
      conn = post(conn, taxi_path(conn, :create), taxi: @create_attrs)
      taxi = InternalAccounts.get_taxi!(json_response(conn, 201)["data"]["id"])

      assert json_response(conn, 201) == render_json(TaxiView, "show.json", %{taxi: taxi})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, taxi_path(conn, :create), taxi: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "POST /create, when user is not an admin" do
    setup [:authenticate_taxi]

    test "renders unauthorized", %{conn: conn} do
      conn = post(conn, taxi_path(conn, :create), taxi: @create_attrs)
      assert json_response(conn, 401)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "PUT /update, when user is an admin" do
    setup [:create_taxi, :authenticate_admin]

    test "renders taxi show when data is valid", %{conn: conn, taxi: %Taxi{id: id} = taxi} do
      conn = put(conn, taxi_path(conn, :update, taxi), taxi: @update_attrs)
      taxi = InternalAccounts.get_taxi!(id)

      assert json_response(conn, 200) == render_json(TaxiView, "show.json", %{taxi: taxi})
      assert json_response(conn, 200)["data"]["cpf"] == "12345678910"
    end

    test "renders errors when data is invalid", %{conn: conn, taxi: taxi} do
      conn = put(conn, taxi_path(conn, :update, taxi), taxi: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PUT /update, when user is not an admin" do
    setup [:create_taxi, :authenticate_taxi]

    test "renders unauthorized", %{conn: conn, taxi: taxi} do
      conn = put(conn, taxi_path(conn, :update, taxi), taxi: @update_attrs)
      assert json_response(conn, 401)["error"] == "Você não pode acessar esse recurso"
    end
  end

  defp create_taxi(_) do
    %{taxi: insert(:taxi)}
  end

  defp authenticate_admin(%{conn: conn}) do
    authenticate(conn, insert(:admin))
  end

  defp authenticate_taxi(%{conn: conn}) do
    authenticate(conn, insert(:taxi))
  end
end
