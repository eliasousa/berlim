defmodule BerlimWeb.VoucherView do
  use BerlimWeb, :view
  alias BerlimWeb.VoucherView

  def render("index.json", %{vouchers: vouchers}) do
    %{data: render_many(vouchers, VoucherView, "voucher.json")}
  end

  def render("show.json", %{voucher: voucher}) do
    %{data: render_one(voucher, VoucherView, "voucher.json")}
  end

  def render("voucher.json", %{voucher: voucher}) do
    %{
      id: voucher.id,
      value: voucher.value,
      from: voucher.from,
      to: voucher.to,
      km: voucher.km,
      note: voucher.note,
      payed_at: voucher.payed_at,
      company: company_json(voucher.employee.company),
      employee: employee_json(voucher.employee),
      taxi: taxi_json(voucher.taxi)
    }
  end

  defp company_json(%{} = company), do: %{id: company.id, name: company.name}

  defp employee_json(%{} = employee), do: %{id: employee.id, name: employee.name}

  defp taxi_json(%{} = taxi), do: %{id: taxi.id, smtt: taxi.smtt}
end
