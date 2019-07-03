defmodule BerlimWeb.Old.TaxiControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  describe "GET /show, when smtt match with password" do
    setup [:authenticate]

    test "renders taxi", %{conn: conn} do
      taxi = insert_user_with_this_password(:taxi, "123456")

      conn =
        get(
          conn,
          Routes.old_taxi_path(conn, :show, %{
            "vt" => taxi.smtt,
            "password" => "123456"
          })
        )

      assert List.first(json_response(conn, 200)) == %{"id" => taxi.id}
    end
  end

  describe "GET /show, when smtt does not match with password" do
    setup [:authenticate]

    test "renders false", %{conn: conn} do
      taxi = insert_user_with_this_password(:taxi, "123456")

      conn =
        get(
          conn,
          Routes.old_taxi_path(conn, :show, %{
            "vt" => taxi.smtt,
            "password" => "invalid_pass"
          })
        )

      refute json_response(conn, 200)
    end
  end

  describe "GET /show, with invalid params" do
    setup [:authenticate]

    test "renders false", %{conn: conn} do
      conn = get(conn, Routes.old_taxi_path(conn, :show, %{}))

      refute json_response(conn, 200)
    end
  end

  defp authenticate(%{conn: conn}) do
    authenticate_with_token(conn)
  end
end
