defmodule Berlim.Guardian do
  @moduledoc """
  The Guardian file
  """

  use Guardian, otp_app: :berlim
  alias Berlim.{CompanyAccounts, InternalAccounts}

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id, "type" => "Admin"}) do
    user = InternalAccounts.get_admin!(id)
    {:ok, user}
  end

  def resource_from_claims(%{"sub" => id, "type" => "Company"}) do
    user = CompanyAccounts.get_company!(id)
    {:ok, user}
  end

  def resource_from_claims(%{"sub" => id, "type" => "Taxi"}) do
    user = InternalAccounts.get_taxi!(id)
    {:ok, user}
  end

  def resource_from_claims(%{"sub" => _, "type" => _}) do
    {:error, :resource_not_found}
  end
end
