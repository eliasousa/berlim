defmodule Berlim.Vouchers.VoucherTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.Vouchers.Voucher

  # test "changeset with valid attributes" do
  #   changeset = Voucher.changeset(%Voucher{}, voucher_params())
  #   assert changeset.valid?
  # end

  # test "changeset with invalid attributes" do
  #   changeset = Voucher.changeset(%Voucher{}, %{})
  #   refute changeset.valid?
  # end

  test "taxi does not exist" do
    voucher = Voucher.changeset(%Voucher{}, insert(:admin), %{voucher_params() | taxi_id: 0})
    assert {:error, changeset} = Repo.insert(voucher)
    assert %{taxi_id: ["does not exist"]} = errors_on(changeset)
  end

  # test "taxi is required" do
  #   changeset = Voucher.changeset(%Voucher{}, params_for(:voucher))
  #   assert %{taxi_id: ["can't be blank"]} = errors_on(changeset)
  # end

  defp voucher_params do
    params_with_assocs(:voucher)
  end
end
