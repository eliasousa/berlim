defmodule Berlim.Email do
  @moduledoc false

  import Swoosh.Email

  def welcome(email, username, password) do
    base_email()
    |> to({"", email})
    |> put_provider_option(:template_id, "d-8583f55b7332474ab864a9372d48c04f")
    |> put_provider_option(:dynamic_template_data, %{username: username, password: password})
  end

  def voucher_receipt(email, voucher) do
    base_email()
    |> to({"", email})
    |> put_provider_option(:template_id, "d-5f3a08dd68c045a7802d76081a973a0f")
    |> put_provider_option(:dynamic_template_data, %{
      id: voucher.id,
      smtt: voucher.taxi.smtt,
      inserted_at: voucher.inserted_at,
      company: voucher.employee.company.name,
      employee: voucher.employee.name,
      from: voucher.from,
      to: voucher.to,
      km: voucher.km,
      note: voucher.note,
      value: voucher.value
    })
  end

  defp base_email do
    new()
    |> from({"Voo de Taxi", "naoresponda@voodetaxi.com.br"})
    |> text_body("nil")
  end
end
