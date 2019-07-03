defmodule Berlim.Vouchers do
  @moduledoc """
  The Vouchers context.
  """

  alias Berlim.Repo

  alias Berlim.{
    CompanyAccounts.Company,
    InternalAccounts.Taxi,
    Vouchers.Voucher
  }

  def list_vouchers() do
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
      {:ok, Repo.preload(voucher, [:taxi, :employee, employee: :company])}
    end
  end

  def change_voucher(voucher \\ %Voucher{}, voucher_attrs \\ %{}) do
    Voucher.changeset(voucher, voucher_attrs)
  end
end
