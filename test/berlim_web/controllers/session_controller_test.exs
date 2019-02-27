defmodule BerlimWeb.SessionControllerTest do
  use BerlimWeb.ConnCase, async: true

  import Berlim.Factory

  alias BerlimWeb.SessionView

  describe "POST /create" do
    test "renders token if logged successfully", %{conn: conn} do
      admin = insert_user_with_this_password(:admin, "123456")
      conn = post(conn, session_path(conn, :create), %{email: admin.email, password: "123456"})

      %{token: token} = conn.assigns
      assert json_response(conn, 200) == render_json(SessionView, "account.json", %{token: token})
    end

    test "renders unauthorized of login failed", %{conn: conn} do
      conn =
        post(conn, session_path(conn, :create), %{email: "john@email.com", password: "123456"})

      assert json_response(conn, 401)["error"] == "Login error"
    end
  end
end
