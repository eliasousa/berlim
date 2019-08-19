defmodule BerlimWeb.VoucherView do
  use BerlimWeb, :view
  alias BerlimWeb.VoucherView

  def render("index.json", %{vouchers: vouchers}) do
    %{data: render_many(vouchers, VoucherView, "voucher.json")}
  end

  def render("show.json", %{voucher: voucher}) do
    %{data: render_one(voucher, VoucherView, "voucher.json")}
  end

  def render("update.json", %{total_paid: total_paid}) do
    %{data: %{total_paid: total_paid}}
  end

  def render("voucher.json", %{voucher: voucher}) do
    %{
      id: voucher.id,
      value: voucher.value,
      from: voucher.from,
      to: voucher.to,
      km: voucher.km,
      note: voucher.note,
      inserted_at: voucher.inserted_at,
      payed_at: voucher.payed_at,
      company: company_json(voucher.employee.company),
      employee: employee_json(voucher.employee),
      taxi: taxi_json(voucher.taxi)
    }
  end

  defp company_json(%{} = company), do: %{id: company.id, name: company.name}

  defp employee_json(%{} = employee),
    do: %{
      id: employee.id,
      internal_id: employee.internal_id,
      name: employee.name,
      sector: sector_json(employee.sector)
    }

  defp taxi_json(%{} = taxi), do: %{id: taxi.id, smtt: taxi.smtt}
  defp sector_json(%{} = sector), do: %{id: sector.id, name: sector.name}
  defp sector_json(_), do: nil
end
