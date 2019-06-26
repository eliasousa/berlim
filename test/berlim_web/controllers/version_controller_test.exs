defmodule BerlimWeb.VersionControllerTest do
  use BerlimWeb.ConnCase, async: true

  describe "GET /versions" do
    test "renders current app version", %{conn: conn} do
      conn = get(conn, Routes.version_path(conn, :index), %{})

      assert json_response(conn, 200) == %{"app_version" => 1}
    end
  end
end
