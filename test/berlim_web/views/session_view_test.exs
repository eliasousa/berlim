defmodule BerlimWeb.SessionViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.SessionView

  test "renders jwt token" do
    assert SessionView.render("jwt.json", jwt: "jwt_token") == %{jwt: "jwt_token"}
  end
end
