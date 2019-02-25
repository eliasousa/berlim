defmodule BerlimWeb.UserViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.UserView

  test "renders jwt token" do
    assert UserView.render("jwt.json", jwt: "jwt_token") == %{jwt: "jwt_token"}
  end
end
