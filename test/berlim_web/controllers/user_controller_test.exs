defmodule BerlimWeb.UserControllerTest do
  use BerlimWeb.ConnCase

  import Berlim.Factory

  alias BerlimWeb.UserView

  describe "POST /create" do
    test "renders jwt token if logged successfully", %{conn: conn} do
      admin = insert_user_with_this_password(:admin, "123456")
      conn = post(conn, user_path(conn, :create), %{email: admin.email, password: "123456"})

      %{jwt: jwt} = conn.assigns
      assert json_response(conn, 200) == render_json(UserView, "jwt.json", %{jwt: jwt})
    end

    test "renders unauthorized of login failed", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), %{email: "john@email.com", password: "123456"})

      assert json_response(conn, 401)["error"] == "Login error"
    end
  end
end
