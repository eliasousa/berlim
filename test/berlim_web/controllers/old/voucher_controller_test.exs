defmodule BerlimWeb.Old.VoucherControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  describe "GET /index, when exists not payed vouchers" do
    setup [:authenticate]

    test "renders not payed taxi vouchers", %{conn: conn} do
      taxi = insert(:taxi)
      build(:voucher, taxi: taxi) |> insert()
      not_payed_voucher = build(:voucher, %{taxi: taxi, payed_at: nil}) |> insert()

      conn = get(conn, Routes.old_voucher_path(conn, :index, taxi.id))

      assert Enum.count(json_response(conn, 200)) == 1
      assert List.first(json_response(conn, 200))["id"] == not_payed_voucher.id
    end
  end

  describe "GET /index, when does not exists not payed vouchers" do
    setup [:authenticate]

    test "renders false", %{conn: conn} do
      taxi = insert(:taxi)
      build(:voucher, taxi: taxi) |> insert()

      conn = get(conn, Routes.old_voucher_path(conn, :index, taxi.id))

      refute json_response(conn, 200)
    end
  end

  describe "GET /index, with invalid params" do
    setup [:authenticate]

    test "renders false", %{conn: conn} do
      conn = get(conn, Routes.old_voucher_path(conn, :index, 0))

      refute json_response(conn, 200)
    end
  end

  defp authenticate(%{conn: conn}) do
    authenticate_with_token(conn)
  end
end
