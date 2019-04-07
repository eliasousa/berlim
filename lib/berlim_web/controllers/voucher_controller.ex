defmodule BerlimWeb.VoucherController do
  use BerlimWeb, :controller

  alias Berlim.Vouchers
  alias Berlim.Vouchers.Voucher

  action_fallback BerlimWeb.FallbackController

  def index(conn, _params) do
    vouchers = Vouchers.list_vouchers()
    render(conn, "index.json", vouchers: vouchers)
  end

  def create(conn, %{"voucher" => voucher_params}) do
    with {:ok, %Voucher{} = voucher} <- Vouchers.create_voucher(voucher_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.voucher_path(conn, :show, voucher))
      |> render("show.json", voucher: voucher)
    end
  end

  def show(conn, %{"id" => id}) do
    voucher = Vouchers.get_voucher!(id)
    render(conn, "show.json", voucher: voucher)
  end

  def update(conn, %{"id" => id, "voucher" => voucher_params}) do
    voucher = Vouchers.get_voucher!(id)

    with {:ok, %Voucher{} = voucher} <- Vouchers.update_voucher(voucher, voucher_params) do
      render(conn, "show.json", voucher: voucher)
    end
  end

  def delete(conn, %{"id" => id}) do
    voucher = Vouchers.get_voucher!(id)

    with {:ok, %Voucher{}} <- Vouchers.delete_voucher(voucher) do
      send_resp(conn, :no_content, "")
    end
  end
end
