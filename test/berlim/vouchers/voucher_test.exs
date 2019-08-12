defmodule Berlim.Vouchers.VoucherTest do
  use Berlim.DataCase, async: true
  use Timex

  import Berlim.Factory

  alias Berlim.Vouchers.Voucher

  test "changeset/2 with valid attributes" do
    changeset = Voucher.changeset(%Voucher{}, voucher_params())
    assert changeset.valid?
  end

  test "changeset/2 with invalid attributes" do
    changeset = Voucher.changeset(%Voucher{}, %{})
    refute changeset.valid?
  end

  test "taxi does not exist" do
    voucher = Voucher.changeset(%Voucher{}, %{voucher_params() | taxi_id: 0})
    assert {:error, changeset} = Repo.insert(voucher)
    assert %{taxi_id: ["does not exist"]} = errors_on(changeset)
  end

  test "employee does not exist" do
    voucher = Voucher.changeset(%Voucher{}, %{voucher_params() | employee_id: 0})
    assert {:error, changeset} = Repo.insert(voucher)
    assert %{employee_id: ["does not exist"]} = errors_on(changeset)
  end

  defp voucher_params do
    params_with_assocs(:voucher)
  end
end
