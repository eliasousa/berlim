defmodule BerlimWeb.Old.VoucherView do
  use BerlimWeb, :view
  alias BerlimWeb.Old.VoucherView

  def render("index.json", %{vouchers: vouchers}) do
    render_many(vouchers, VoucherView, "voucher.json")
  end

  def render("voucher.json", %{voucher: voucher}) do
    %{
      id: voucher.id,
      valor: voucher.value,
      pago: false,
      empresa: %{nome: voucher.employee.company.name}
    }
  end
end
