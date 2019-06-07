defmodule BerlimWeb.VoucherControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  alias Berlim.Vouchers
  alias BerlimWeb.VoucherView

  @invalid_attrs %{value: nil}

  describe "GET /index, when user is admin" do
    setup [:authenticate_admin]

    test "list all vouchers", %{conn: conn} do
      insert_list(3, :voucher)

      conn = get(conn, Routes.voucher_path(conn, :index))

      vouchers = json_response(conn, 200)["data"]

      assert is_list(vouchers)
      assert Enum.count(vouchers) == 3
    end
  end

  describe "GET /show" do
    setup [:authenticate_taxi, :create_voucher]

    test "renders voucher", %{conn: conn, voucher: voucher} do
      conn = get(conn, Routes.voucher_path(conn, :show, voucher))

      assert json_response(conn, 200) ==
               render_json(VoucherView, "show.json", %{voucher: voucher})
    end
  end

  describe "POST /create" do
    setup [:authenticate_taxi]

    test "renders voucher when data is valid", %{conn: conn} do
      conn = post(conn, Routes.voucher_path(conn, :create), voucher: create_attrs())

      voucher = Vouchers.get_voucher!(json_response(conn, 201)["data"]["id"])

      assert json_response(conn, 201) ==
               render_json(VoucherView, "show.json", %{voucher: voucher})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.voucher_path(conn, :create, voucher: @invalid_attrs))

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp authenticate_admin(%{conn: conn}) do
    authenticate(conn, insert(:admin))
  end

  defp authenticate_company(%{conn: conn}) do
    authenticate(conn, insert(:company))
  end

  defp authenticate_taxi(%{conn: conn}) do
    authenticate(conn, insert(:taxi))
  end

  defp create_attrs do
    params_for(:voucher, %{employee: insert(:employee), taxi: insert(:taxi)})
  end

  defp create_voucher(_) do
    %{voucher: insert(:voucher)}
  end
end
