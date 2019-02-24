defmodule Berlim.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Berlim.{Guardian, InternalAccounts.Admin, InternalAccounts.Taxi, Repo}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        type = user.__struct__ |> Module.split() |> List.last()
        Guardian.encode_and_sign(user, %{type: type})

      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
         do: verify_password(password, user)
  end

  defp get_by_email(email) when is_binary(email) do
    cond do
      admin = Repo.get_by(Admin, email: email) ->
        {:ok, admin}

      taxi = Repo.get_by(Taxi, email: email) ->
        {:ok, taxi}

      true ->
        dummy_checkpw()
        {:error, "Login error."}
    end
  end

  defp verify_password(password, user) when is_binary(password) do
    if checkpw(password, user.encrypted_password) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
