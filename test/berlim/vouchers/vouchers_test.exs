# defmodule Berlim.VouchersTest do
#   use Berlim.DataCase

#   alias Berlim.Vouchers

#   describe "vouchers" do
#     alias Berlim.Vouchers.Voucher

#     @valid_attrs %{
#       from: "some from",
#       km: "some km",
#       note: "some note",
#       payed_at: ~N[2010-04-17 14:00:00],
#       to: "some to",
#       value: 120.5
#     }
#     @update_attrs %{
#       from: "some updated from",
#       km: "some updated km",
#       note: "some updated note",
#       payed_at: ~N[2011-05-18 15:01:01],
#       to: "some updated to",
#       value: 456.7
#     }
#     @invalid_attrs %{from: nil, km: nil, note: nil, payed_at: nil, to: nil, value: nil}

#     def voucher_fixture(attrs \\ %{}) do
#       {:ok, voucher} =
#         attrs
#         |> Enum.into(@valid_attrs)
#         |> Vouchers.create_voucher()

#       voucher
#     end

#     test "list_vouchers/0 returns all vouchers" do
#       voucher = voucher_fixture()
#       assert Vouchers.list_vouchers() == [voucher]
#     end

#     test "get_voucher!/1 returns the voucher with given id" do
#       voucher = voucher_fixture()
#       assert Vouchers.get_voucher!(voucher.id) == voucher
#     end

#     test "create_voucher/1 with valid data creates a voucher" do
#       assert {:ok, %Voucher{} = voucher} = Vouchers.create_voucher(@valid_attrs)
#       assert voucher.from == "some from"
#       assert voucher.km == "some km"
#       assert voucher.note == "some note"
#       assert voucher.payed_at == ~N[2010-04-17 14:00:00]
#       assert voucher.to == "some to"
#       assert voucher.value == 120.5
#     end

#     test "create_voucher/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Vouchers.create_voucher(@invalid_attrs)
#     end

#     test "update_voucher/2 with valid data updates the voucher" do
#       voucher = voucher_fixture()
#       assert {:ok, %Voucher{} = voucher} = Vouchers.update_voucher(voucher, @update_attrs)
#       assert voucher.from == "some updated from"
#       assert voucher.km == "some updated km"
#       assert voucher.note == "some updated note"
#       assert voucher.payed_at == ~N[2011-05-18 15:01:01]
#       assert voucher.to == "some updated to"
#       assert voucher.value == 456.7
#     end

#     test "update_voucher/2 with invalid data returns error changeset" do
#       voucher = voucher_fixture()
#       assert {:error, %Ecto.Changeset{}} = Vouchers.update_voucher(voucher, @invalid_attrs)
#       assert voucher == Vouchers.get_voucher!(voucher.id)
#     end

#     test "delete_voucher/1 deletes the voucher" do
#       voucher = voucher_fixture()
#       assert {:ok, %Voucher{}} = Vouchers.delete_voucher(voucher)
#       assert_raise Ecto.NoResultsError, fn -> Vouchers.get_voucher!(voucher.id) end
#     end

#     test "change_voucher/1 returns a voucher changeset" do
#       voucher = voucher_fixture()
#       assert %Ecto.Changeset{} = Vouchers.change_voucher(voucher)
#     end
#   end
# end
