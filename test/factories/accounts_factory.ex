defmodule Berlim.AccountsFactory do
  @moduledoc """
  Factory for modules inside the `Accounts` context
  """

  defmacro __using__(_opts) do
    quote do
      def admin_factory do
        %Berlim.Accounts.Admin{
          name: "John Doe",
          email: sequence(:email, &"email-#{&1}@example.com"),
          password: "1234abcd",
          active: true,
          phone: "7932120600"
        }
      end

      def taxi_factory do
        %Berlim.Accounts.Taxi{
          email: sequence(:email, &"email-#{&1}@example.com"),
          password: "1234abcd",
          active: true,
          phone: "7932120600",
          smtt: sequence(:smtt, &"1234#{&1}"),
          cpf: "02005445698"
        }
      end
    end
  end
end
