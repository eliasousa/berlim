defmodule Berlim.SalesFactory do
  @moduledoc """
  Factory for modules inside the `Sales` context
  """

  defmacro __using__(_opts) do
    quote do
      def customer_factory do
        %Berlim.Sales.Customer{
          fullname: "John Doe",
          email: sequence(:email, &"email-#{&1}@example.com"),
          phone: "7932120600",
          address_street: "Rua A",
          address_street_number: "3",
          address_complement: "Prox a farmacia",
          address_city_code: 54,
          address_city_name: "Aracaju",
          address_state: "SE",
          address_zipcode: "49140000",
          address_district: "Ponto Novo",
          address_country: "BRA"
        }
      end

      def order_factory do
        %Berlim.Sales.Order{
          value: 150,
          status: :approved,
          type: :credit_card,
          approved_at: DateTime.utc_now(),
          monthly_date: Date.utc_today()
        }
      end
    end
  end
end
