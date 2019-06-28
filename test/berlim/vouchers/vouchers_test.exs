defmodule Berlim.VouchersTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory
  import Swoosh.TestAssertions

  alias Berlim.{Email, Vouchers}

  @invalid_attrs %{value: nil}

  defp voucher_params do
    params_with_assocs(:voucher)
  end

  test "list_vouchers/0 returns all vouchers" do
    voucher = insert(:voucher)
    vouchers = Vouchers.list_vouchers()

    assert List.first(vouchers).id == voucher.id
    assert Enum.count(vouchers) == 1
  end

  test "get_voucher!/1, returns the voucher with the given id" do
    voucher = insert(:voucher)

    assert Vouchers.get_voucher!(voucher.id).id == voucher.id
  end

  test "create_voucher/1 with valid data, creates a voucher" do
    assert {:ok, voucher} = Vouchers.create_voucher(voucher_params())
    assert_email_sent(Email.voucher_receipt(voucher.taxi.email, voucher))
    assert_email_sent(Email.voucher_receipt(voucher.employee.email, voucher))
    assert_email_sent(Email.voucher_receipt(voucher.employee.company.email, voucher))
    assert voucher.to == "São Paulo"
  end

  test "create_voucher/2 with invalid data, returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Vouchers.create_voucher(@invalid_attrs)
  end
end
