defmodule BerlimWeb.UserController do
  use BerlimWeb, :controller

  alias Berlim.Accounts
  alias BerlimWeb.UserView

  action_fallback(BerlimWeb.FallbackController)

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn
        |> put_view(UserView)
        |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end
end
