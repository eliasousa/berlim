defmodule Berlim.AccountsFactory do
  @moduledoc """
  Factory for modules inside the `Accounts` context
  """
  alias Berlim.{
    Accounts.Admin,
    Accounts.Taxi
  }

  defmacro __using__(_opts) do
    quote do
      def admin_factory do
        %Admin{
          name: "John Doe",
          email: sequence(:email, &"email-#{&1}@example.com"),
          encrypted_password: "1234abcd",
          active: true,
          phone: "7932120600"
        }
      end

      def taxi_factory do
        %Taxi{
          email: sequence(:email, &"email-#{&1}@example.com"),
          encrypted_password: "1234abcd",
          active: true,
          phone: "7932120600",
          smtt: sequence(:smtt, &"1234#{&1}"),
          cpf: "02005445698"
        }
      end

      def insert_user_with_this_password(user, password) when is_atom(user) do
        user
        |> build()
        |> set_password(password)
        |> insert()
      end

      defp set_password(user, password) do
        user
        |> user.__struct__.changeset(%{encrypted_password: password})
        |> Ecto.Changeset.apply_changes()
      end
    end
  end
end
