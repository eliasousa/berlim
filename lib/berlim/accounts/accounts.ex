defmodule Berlim.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Berlim.{
    CompanyAccounts.Company,
    Guardian,
    InternalAccounts.Admin,
    InternalAccounts.Taxi,
    Repo
  }

  import Bcrypt, only: [verify_pass: 2, no_user_verify: 0]

  @spec token_sign_in(String.t(), String.t()) ::
          {:ok, String.t(), struct()} | {:error, :unauthorised}
  def token_sign_in(username, password) do
    case authenticate_user(username, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user, %{type: get_user_type(user)}, ttl: {24, :hours})

      {:error, :invalid_credentials} ->
        {:error, :unauthorized}
    end
  end

  defp authenticate_user(username, password) when is_binary(username) and is_binary(password) do
    with {:ok, user} <- get_by_username(username), do: verify_password(password, user)
  end

  defp get_by_username(username) do
    cond do
      admin = Repo.get_by(Admin, email: username, active: true) ->
        {:ok, admin}

      company = Repo.get_by(Company, email: username, active: true) ->
        {:ok, company}

      taxi = Repo.get_by(Taxi, email: username, active: true) ->
        {:ok, taxi}

      taxi = get_taxi_by_smtt(username) ->
        {:ok, taxi}

      true ->
        no_user_verify()
        {:error, :invalid_credentials}
    end
  end

  defp verify_password(password, user) when is_binary(password) do
    if verify_pass(password, user.encrypted_password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  defp get_taxi_by_smtt(username) do
    case Integer.parse(username) do
      {_, ""} -> Repo.get_by(Taxi, smtt: username, active: true)
      _ -> nil
    end
  end

  def get_user_type(user) do
    user.__struct__ |> Module.split() |> List.last()
  end
end
