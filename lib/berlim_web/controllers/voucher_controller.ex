defmodule BerlimWeb.VoucherController do
  use BerlimWeb, :controller

  alias Berlim.{
    Vouchers,
    Vouchers.Voucher
  }

  action_fallback BerlimWeb.FallbackController

  def index(%{assigns: %{admin: _admin}} = conn, _params) do
    vouchers = Vouchers.list_vouchers()
    render(conn, "index.json", vouchers: vouchers)
  end

  def index(%{assigns: %{company: company}} = conn, _params) do
    vouchers = Vouchers.list_company_vouchers(company)
    render(conn, "index.json", vouchers: vouchers)
  end

  def index(%{assigns: %{taxi: taxi}} = conn, _params) do
    vouchers = Vouchers.list_taxi_vouchers(taxi)
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
