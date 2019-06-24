defmodule BerlimWeb.VersionControllerTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.VersionView

  describe "GET /versions" do
    test "renders current app version", %{conn: conn} do
      System.put_env("APP_VERSION", "999")

      conn = get(conn, Routes.version_path(conn, :index), %{})

      assert json_response(conn, 200) ==
               render_json(VersionView, "index.json", %{app_version: "999"})
    end
  end
end
