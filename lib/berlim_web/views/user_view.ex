defmodule BerlimWeb.UserView do
  use BerlimWeb, :view

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
