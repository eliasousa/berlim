defmodule Berlim.VouchersFactory do
  @moduledoc """
  Factory for modules inside the 'Vouchers' context.
  """
  alias Berlim.Vouchers.Voucher

  defmacro __using__(_opts) do
    quote do
      def voucher_factory do
        %Voucher{
          from: "Aracaju",
          km: "500",
          note: "Voucher test",
          to: "São Paulo",
          value: 100,
          paid_at: DateTime.utc_now(),
          employee: build(:employee),
          taxi: build(:taxi),
          paid_by: build(:admin)
        }
      end
    end
  end
end
