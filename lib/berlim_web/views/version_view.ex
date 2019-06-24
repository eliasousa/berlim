defmodule BerlimWeb.VersionView do
  use BerlimWeb, :view

  def render("index.json", %{app_version: app_version}) do
    %{app_version: app_version}
  end
end
