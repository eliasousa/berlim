defmodule BerlimWeb.DashboardControllerTest do
  use BerlimWeb.ConnCase
  use BerlimWeb.Helpers.AuthHelper

  describe "GET /index, when user is authenticated" do
    setup %{conn: conn} do
      %{conn: authenticate(conn)}
    end

    test "shows dashboard page", %{conn: conn} do
      conn = get(conn, Routes.dashboard_path(conn, :index))
      assert html_response(conn, 200) =~ "Dashboard"
    end
  end
end
