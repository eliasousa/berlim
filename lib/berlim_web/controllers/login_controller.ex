defmodule BerlimWeb.LoginController do
  use BerlimWeb, :controller

  alias Berlim.{
    Accounts,
    Accounts.Admin,
    Accounts.Taxi
  }

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"auth_params" => auth_params}) do
    case Accounts.authenticate_user(auth_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Login efetuado com sucesso")
        |> redirect_after_authentication(user)

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Email ou senha incorretos")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Você saiu da sua conta")
    |> redirect(to: Routes.home_path(conn, :index))
  end

  defp redirect_after_authentication(conn, user) do
    case user do
      %Admin{} ->
        redirect(conn, to: Routes.admin_path(conn, :index))

      %Taxi{} ->
        redirect(conn, to: Routes.dashboard_path(conn, :index))
    end
  end
end
