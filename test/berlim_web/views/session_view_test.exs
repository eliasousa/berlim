defmodule BerlimWeb.SessionViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.SessionView

  test "renders token" do
    assert %{token: "token"} = SessionView.render("account.json", token: "token")
  end
end
