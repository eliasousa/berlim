defmodule Berlim.Guardian do
  @moduledoc """
  The Guardian file
  """

  use Guardian, otp_app: :berlim
  alias Berlim.InternalAccounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id, "type" => type}) do
    case get_resource(id, type) do
      nil ->
        {:error, :resource_not_found}

      user ->
        {:ok, user}
    end
  end

  defp get_resource(id, type) do
    case type do
      "Admin" ->
        InternalAccounts.get_admin!(id)

      "Taxi" ->
        InternalAccounts.get_taxi!(id)

      _ ->
        nil
    end
  end
end
