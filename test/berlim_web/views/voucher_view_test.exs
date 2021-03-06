defmodule BerlimWeb.VoucherViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.VoucherView

  setup do
    employee = %{
      id: 1,
      internal_id: "1234",
      name: "Elias",
      sector: %{id: 1, name: "Financeiro"},
      company: %{id: 1, name: "Voo"}
    }

    %{
      voucher: %{
        id: 1,
        value: 150,
        km: "300",
        note: "Voucher view",
        from: "Ponto Novo",
        to: "Av. Rio de Janeiro",
        inserted_at: DateTime.utc_now(),
        paid_at: DateTime.utc_now(),
        company: employee.company,
        employee: employee,
        taxi: %{id: 1, smtt: 1234}
      }
    }
  end

  test "index.json/2, returns vouchers", %{voucher: voucher} do
    assert VoucherView.render("index.json", %{vouchers: [voucher]}) == %{
             data: [%{voucher | employee: Map.delete(voucher.employee, :company)}]
           }
  end

  test "show.json/2, returns voucher", %{voucher: voucher} do
    assert VoucherView.render("show.json", %{voucher: voucher}) == %{
             data: %{voucher | employee: Map.delete(voucher.employee, :company)}
           }
  end

  test "update.json/2, returns updated count" do
    assert VoucherView.render("update.json", %{total_paid: 10}) == %{data: %{total_paid: 10}}
  end

  test "voucher.json/2, returns voucher", %{voucher: voucher} do
    assert VoucherView.render("voucher.json", %{voucher: voucher}) == %{
             voucher
             | employee: Map.delete(voucher.employee, :company)
           }
  end
end
