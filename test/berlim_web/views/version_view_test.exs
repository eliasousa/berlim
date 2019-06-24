defmodule BerlimWeb.VersionViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.VersionView

  test "renders app_version" do
    assert %{app_version: "1"} = VersionView.render("index.json", app_version: "1")
  end
end
