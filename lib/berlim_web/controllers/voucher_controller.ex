defmodule BerlimWeb.VoucherController do
  use BerlimWeb, :controller

  alias Berlim.{
    Vouchers,
    Vouchers.Voucher
  }

  action_fallback BerlimWeb.FallbackController
  plug BerlimWeb.Plugs.VoucherFiltersValidator when action in [:index]

  def index(%{assigns: %{admin: _admin, filters: filters}} = conn, _params) do
    vouchers = Vouchers.list_vouchers(filters)
    render(conn, "index.json", vouchers: vouchers)
  end

  def index(%{assigns: %{company: company, filters: filters}} = conn, _params) do
    vouchers = Vouchers.list_company_vouchers(company, filters)
    render(conn, "index.json", vouchers: vouchers)
  end

  def index(%{assigns: %{taxi: taxi, filters: filters}} = conn, _params) do
    vouchers = Vouchers.list_taxi_vouchers(taxi, filters)
    render(conn, "index.json", vouchers: vouchers)
  end

  def create(conn, %{"voucher" => voucher_params}) do
    with {:ok, %Voucher{} = voucher} <- Vouchers.create_voucher(voucher_params) do
      conn
      |> put_status(:created)
      |> render("show.json", voucher: voucher)
    end
  end

  def show(conn, %{"id" => id}) do
    voucher = Vouchers.get_voucher!(id)
    render(conn, "show.json", voucher: voucher)
  end
end
