defmodule BerlimWeb.Plugs.VoucherFiltersValidator do
  @moduledoc """
  The voucher filters validator Plug
  """
  use Phoenix.Controller
  use Timex

  import Plug.Conn

  @date_params ~w(payed_start_at payed_end_at created_start_at created_end_at)
  @integer_params ~w(company_id employee_id sector_id taxi_id voucher_id)
  def init(params), do: params

  def call(%{assigns: %{admin: _admin}} = conn, _params) do
    ~w(company_id employee_id taxi_id voucher_id)
    |> validate_and_assign_filters(conn)
  end

  def call(%{assigns: %{company: _company}} = conn, _params) do
    ~w(employee_id matricula sector_id)
    |> validate_and_assign_filters(conn)
  end

  def call(conn, _params) do
    validate_and_assign_filters(conn)
  end

  defp validate_and_assign_filters(filters \\ [], conn) do
    parsed_filters =
      @date_params
      |> Enum.concat(filters)
      |> parse_params(conn.params)

    case errors = filter_malformed_params(parsed_filters) do
      [] ->
        assign_filters(parsed_filters, conn)

      _ ->
        error_return_and_halt(conn, errors)
    end
  end

  defp parse_params(filters, params) do
    Enum.flat_map(params, fn {key, value} ->
      with true <- Enum.member?(filters, key),
           {:ok, value} <- validate_param(key, value) do
        [{key, value}]
      else
        {:error, message} -> [{:error, message}]
        _ -> []
      end
    end)
  end

  defp filter_malformed_params(params) do
    Enum.flat_map(params, fn
      {:error, message} -> [message]
      _ -> []
    end)
  end

  defp assign_filters(valid_filters, conn) do
    assign(conn, :filters, valid_filters)
  end

  defp validate_param(param, value) when not is_binary(value) do
    {:error, param_format_error(param, value)}
  end

  defp validate_param(param, value) when param in @date_params do
    parse_date(param, value)
  end

  defp validate_param(param, value) when param in @integer_params do
    parse_integer(param, value)
  end

  defp validate_param(_param, value), do: {:ok, value}

  defp parse_date(param, string_date) do
    case Timex.parse(string_date, "{ISO:Extended:Z}") do
      {:ok, datetime} ->
        {:ok, datetime}

      {:error, _error} ->
        {:error, param_format_error(param, string_date)}
    end
  end

  defp parse_integer(param, number) do
    case Integer.parse(number) do
      {integer, ""} ->
        {:ok, integer}

      _error ->
        {:error, param_format_error(param, number)}
    end
  end

  defp param_format_error(param, value) do
    "Invalid #{param} format, value: #{value}"
  end

  defp error_return_and_halt(conn, errors) do
    conn
    |> put_status(400)
    |> json(%{error: errors})
    |> halt()
  end
end
