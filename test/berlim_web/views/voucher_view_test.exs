defmodule BerlimWeb.VoucherViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.VoucherView

  setup do
    %{
      voucher: %{
        id: 1,
        value: 150,
        km: "300",
        note: "Voucher view",
        from: "Ponto Novo",
        to: "Av. Rio de Janeiro",
        payed_at: DateTime.utc_now()
      }
    }
  end

  test "index.json/2, returns vouchers", %{voucher: voucher} do
    assert VoucherView.render("index.json", %{vouchers: [voucher]}) == %{data: [voucher]}
  end

  test "show.json/2, returns voucher", %{voucher: voucher} do
    assert VoucherView.render("show.json", %{voucher: voucher}) == %{data: voucher}
  end

  test "voucher.json/2, returns voucher", %{voucher: voucher} do
    assert VoucherView.render("voucher.json", %{voucher: voucher}) == voucher
  end
end
