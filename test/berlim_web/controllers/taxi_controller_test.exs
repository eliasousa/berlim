defmodule BerlimWeb.TaxiControllerTest do
  use BerlimWeb.ConnCase

  import Berlim.Factory

  alias Berlim.InternalAccounts
  alias Berlim.InternalAccounts.Taxi
  alias BerlimWeb.TaxiView

  @create_attrs params_for(:taxi)
  @update_attrs %{cpf: "12345678910"}
  @invalid_attrs %{cpf: nil, email: nil}

  describe "GET /index" do
    test "list all taxis", %{conn: conn} do
      conn = get(conn, taxi_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "POST /create" do
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

  describe "PUT /update" do
    setup [:create_taxi]

    test "renders taxi show when data is valid", %{conn: conn, taxi: %Taxi{id: id} = taxi} do
      conn = put(conn, taxi_path(conn, :update, taxi), taxi: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, taxi_path(conn, :show, id))

      assert %{
               "id" => id,
               "cpf" => "12345678910"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, taxi: taxi} do
      conn = put(conn, taxi_path(conn, :update, taxi), taxi: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_taxi(_) do
    %{taxi: insert(:taxi)}
  end
end
