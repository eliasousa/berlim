defmodule BerlimWeb.SessionViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.SessionView

  test "renders token" do
    assert SessionView.render("account.json", token: "token") == %{token: "token"}
  end
end
