defmodule BerlimWeb.GuardianTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory
  alias BerlimWeb.Guardian

  test "subject_for_token/2" do
    user = insert(:admin)
    assert Guardian.subject_for_token(user, "_") == {:ok, to_string(user.id)}
  end

  test "resource_from_claims/2 when user is an Admin" do
    user = insert(:admin)
    claims = %{"sub" => user.id, "type" => "Admin"}
    assert Guardian.resource_from_claims(claims) == {:ok, user}
  end

  test "resource_from_claims/2 when user is a Taxi" do
    user = insert(:taxi)
    claims = %{"sub" => user.id, "type" => "Taxi"}
    assert Guardian.resource_from_claims(claims) == {:ok, user}
  end

  test "resource_from_claims/2 when user is an Company" do
    user = insert(:company)
    claims = %{"sub" => user.id, "type" => "Company"}
    assert Guardian.resource_from_claims(claims) == {:ok, user}
  end

  test "resource_from_claims/2 when user does not exist" do
    claims = %{"sub" => 999, "type" => "Xpto"}
    assert {:error, :resource_not_found} = Guardian.resource_from_claims(claims)
  end
end
