defmodule BerlimWeb.UserView do
  use BerlimWeb, :view
  alias BerlimWeb.UserView

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
