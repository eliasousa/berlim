defmodule BerlimWeb.SessionView do
  use BerlimWeb, :view

  def render("account.json", %{token: token}) do
    %{token: token}
  end
end
