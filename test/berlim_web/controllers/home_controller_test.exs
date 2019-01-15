defmodule BerlimWeb.HomeControllerTest do
  use BerlimWeb.ConnCase

  describe "GET /index, when user is not authenticated" do
    test "shows home page", %{conn: conn} do
      conn = get(conn, Routes.home_path(conn, :index))
      assert html_response(conn, 200) =~ "Home"
    end
  end
end
