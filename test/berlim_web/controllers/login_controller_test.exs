defmodule BerlimWeb.LoginControllerTest do
  use BerlimWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Bem vindo ao Phoenix!"
  end
end
