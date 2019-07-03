defmodule BerlimWeb.Plugs.ValidateVoucherFilters do
  @moduledoc """
  The validate voucher filters Plug
  """

  import Plug.Conn

  def init(params), do: params

  def call(%{assigns: %{admin: _admin}} = conn, _params) do
    validate_filters(conn, ~w(company_id employee_id taxi_id))
  end

  def call(%{assigns: %{company: _company}} = conn, _params) do
    validate_filters(conn, ~w(employee_id))
  end

  def call(conn, _params) do
    validate_filters(conn)
  end

  defp validate_filters(conn, filters \\ []) do
    filters =
      Enum.concat(~w(payed_start_at payed_end_at created_start_at created_end_at), filters)

    valid_filters =
      Enum.filter(conn.params, fn {key, _value} ->
        Enum.member?(filters, key)
      end)

    assign(conn, :filters, valid_filters)
  end
end
