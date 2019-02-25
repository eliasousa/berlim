defmodule Berlim.Accounts.AccountsTest do
  use Berlim.DataCase

  import Berlim.Factory
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  alias Berlim.Accounts

  test "token_sign_in/2 with valid admin credentials" do
    admin = insert(:admin, %{email: "john@email.com", encrypted_password: hashpwsalt("123456")})

    {:ok, token, claims} = Accounts.token_sign_in("john@email.com", "123456")

    assert token
    assert claims["sub"] == Integer.to_string(admin.id)
    assert claims["type"] == "Admin"
  end

  test "token_sign_in/2 with valid taxi credentials" do
    taxi = insert(:taxi, %{email: "john@email.com", encrypted_password: hashpwsalt("123456")})

    {:ok, token, claims} = Accounts.token_sign_in("john@email.com", "123456")

    assert token
    assert claims["sub"] == Integer.to_string(taxi.id)
    assert claims["type"] == "Taxi"
  end

  test "token_sign_in/2 with invalid credentials" do
    insert(:admin, %{email: "john@email.com", encrypted_password: "123456"})

    assert Accounts.token_sign_in("john@email.com", "12345678") == {:error, :unauthorized}
  end
end
