defmodule BerlimWeb.SessionController do
  use BerlimWeb, :controller

  alias Berlim.Accounts

  action_fallback(BerlimWeb.FallbackController)

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, token, _claims} <- Accounts.token_sign_in(email, password) do
      render(conn, "account.json", token: token)
    end
  end
end
