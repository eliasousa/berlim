defmodule Berlim.Vouchers do
  @moduledoc """
  The Vouchers context.
  """

  alias Berlim.Repo

  alias Berlim.Vouchers.Voucher

  def list_vouchers, do: Repo.all(Voucher)

  def get_voucher!(id), do: Repo.get!(Voucher, id)

  def create_voucher(attrs) do
    %Voucher{}
    |> change_voucher(attrs)
    |> Repo.insert()
  end

  def change_voucher(voucher \\ %Voucher{}, voucher_attrs \\ %{}) do
    Voucher.changeset(voucher, voucher_attrs)
  end
end
