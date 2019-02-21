defmodule BerlimWeb.TaxiControllerTest do
  use BerlimWeb.ConnCase

  import Berlim.Factory
  alias Berlim.InternalAccounts.Taxi

  @create_attrs params_for(:taxi)
  @update_attrs %{cpf: "12345678910"}
  @invalid_attrs %{cpf: nil, email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET /index" do
    test "list all taxis", %{conn: conn} do
      conn = get(conn, Routes.taxi_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "POST /create" do
    test "renders taxi show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.taxi_path(conn, :create), taxi: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.taxi_path(conn, :show, id))

      assert %{
               "id" => id,
               "cpf" => "02005445698"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.taxi_path(conn, :create), taxi: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PUT /update" do
    setup [:create_taxi]

    test "renders taxi show when data is valid", %{conn: conn, taxi: %Taxi{id: id} = taxi} do
      conn = put(conn, Routes.taxi_path(conn, :update, taxi), taxi: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.taxi_path(conn, :show, id))

      assert %{
               "id" => id,
               "cpf" => "12345678910"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, taxi: taxi} do
      conn = put(conn, Routes.taxi_path(conn, :update, taxi), taxi: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_taxi(_) do
    %{taxi: insert(:taxi)}
  end
end
