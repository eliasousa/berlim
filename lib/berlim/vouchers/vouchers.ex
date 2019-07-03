defmodule Berlim.Vouchers do
  @moduledoc """
  The Vouchers context.
  """

  alias Berlim.{EmailGenerator, Mailer, Repo, Vouchers.Voucher}

  def list_vouchers, do: Repo.all(Voucher)

  def get_voucher!(id), do: Repo.get!(Voucher, id)

  def create_voucher(attrs) do
    changeset = change_voucher(%Voucher{}, attrs)

    with {:ok, voucher} <- Repo.insert(changeset) do
      voucher = Repo.preload(voucher, [:taxi, employee: [:company]])

      send_voucher_receipt(voucher.taxi.email, voucher)
      send_voucher_receipt(voucher.employee.email, voucher)
      send_voucher_receipt(voucher.employee.company.email, voucher)

      {:ok, voucher}
    end
  end

  def change_voucher(voucher \\ %Voucher{}, voucher_attrs \\ %{}) do
    Voucher.changeset(voucher, voucher_attrs)
  end

  defp send_voucher_receipt(email, voucher) do
    email |> EmailGenerator.voucher_receipt(voucher) |> Mailer.deliver()
  end
end
