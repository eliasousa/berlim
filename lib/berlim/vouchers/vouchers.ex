defmodule Berlim.Vouchers do
  @moduledoc """
  The Vouchers context.
  """

  alias Berlim.{
    CompanyAccounts.Company,
    EmailGenerator,
    InternalAccounts.Taxi,
    Mailer,
    Repo,
    Vouchers.Voucher
  }

  def list_vouchers do
    Voucher
    |> Voucher.sorted_created_desc()
    |> Voucher.with_associations()
    |> Repo.all()
  end

  def list_taxi_vouchers(%Taxi{} = taxi, filters \\ []) do
    Voucher
    |> Voucher.belongs_to_taxi(taxi.id)
    |> Voucher.query_filtered_by(filters)
    |> Voucher.sorted_created_desc()
    |> Voucher.with_associations()
    |> Repo.all()
  end

  def list_company_vouchers(%Company{} = company, filters \\ []) do
    Voucher
    |> Voucher.belongs_to_company(company.id)
    |> Voucher.query_filtered_by(filters)
    |> Voucher.sorted_created_desc()
    |> Voucher.with_associations()
    |> Repo.all()
  end

  def get_voucher!(id) do
    Voucher
    |> Voucher.with_associations()
    |> Repo.get!(id)
  end

  def create_voucher(attrs) do
    changeset = change_voucher(%Voucher{}, attrs)

    with {:ok, voucher} <- Repo.insert(changeset) do
      voucher = Repo.preload(voucher, [:taxi, employee: :company])

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
