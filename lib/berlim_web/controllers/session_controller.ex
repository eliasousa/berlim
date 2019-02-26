defmodule BerlimWeb.SessionController do
  use BerlimWeb, :controller

  alias Berlim.Accounts
  alias BerlimWeb.SessionView

  action_fallback(BerlimWeb.FallbackController)

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn
        |> put_view(SessionView)
        |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end
end
