defmodule Berlim.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Berlim.{Guardian, InternalAccounts.Admin, InternalAccounts.Taxi, Repo}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @spec token_sign_in(String.t(), String.t()) ::
          {:ok, String.t(), struct()} | {:error, :unauthorised}
  def token_sign_in(email, password) do
    case authenticate_user(email, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user, %{type: get_user_type(user)}, ttl: {24, :hours})

      {:error, :invalid_credentials} ->
        {:error, :unauthorized}
    end
  end

  defp authenticate_user(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email), do: verify_password(password, user)
  end

  defp get_by_email(email) do
    cond do
      admin = Repo.get_by(Admin, email: email) ->
        {:ok, admin}

      taxi = Repo.get_by(Taxi, email: email) ->
        {:ok, taxi}

      true ->
        dummy_checkpw()
        {:error, :invalid_credentials}
    end
  end

  defp verify_password(password, user) when is_binary(password) do
    if checkpw(password, user.encrypted_password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  def get_user_type(user) do
    user.__struct__ |> Module.split() |> List.last()
  end
end
