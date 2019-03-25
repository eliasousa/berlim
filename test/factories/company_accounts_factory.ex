defmodule Berlim.CompanyAccountsFactory do
  @moduledoc """
  Factory for modules inside the `CompanyAccounts` context
  """
  alias Berlim.CompanyAccounts.{Company, Sector}

  defmacro __using__(_opts) do
    quote do
      def company_factory do
        %Company{
          name: "Voo de Taxi",
          cnpj: sequence(:cnpj, &"1234#{&1}"),
          email: sequence(:email, &"email-#{&1}@example.com"),
          encrypted_password: "1234abcd",
          active: true,
          phone: "7932120600"
        }
      end

      def sector_factory do
        %Sector{
          name: "Financeiro",
          company: build(:company)
        }
      end
    end
  end
end
