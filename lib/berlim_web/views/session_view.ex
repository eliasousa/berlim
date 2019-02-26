defmodule BerlimWeb.SessionView do
  use BerlimWeb, :view

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
