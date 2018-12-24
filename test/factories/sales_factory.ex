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
          phone: "+55 (12) 21212-1212",
          tax_document: "379.337.474-26",
          address_street: "Rua XXX",
          address_street_number: "232",
          address_complement: "",
          address_city_code: 2_800_308,
          address_city_name: "Aracaju",
          address_state: "SE",
          address_country: "BRA",
          address_zipcode: "12.121-21212",
          address_district: "13 de Julho"
        }
      end

      def order_factory do
        %Berlim.Sales.Order{
          value: 150,
          status: :approved,
          type: :credit_card,
          approved_at: DateTime.utc_now(),
          monthly_date: Date.utc_today(),
          taxi: build(:taxi)
        }
      end

      def plan_factory do
        %Berlim.Sales.Plan{
          name: "Aracaju",
          value: 200
        }
      end
    end
  end
end
