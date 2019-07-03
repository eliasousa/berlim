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

  describe "GET /index, when user is taxi" do
    setup [:authenticate_taxi]

    test "list all vouchers that belongs to the taxi", %{conn: conn, taxi: taxi} do
      insert_list(5, :voucher, %{taxi: taxi})
      insert_list(3, :voucher)

      conn = get(conn, Routes.voucher_path(conn, :index))

      taxi_vouchers = json_response(conn, 200)["data"]

      assert is_list(taxi_vouchers)
      assert Enum.count(taxi_vouchers) == 5
      assert Enum.all?(taxi_vouchers, fn voucher -> voucher["taxi"]["id"] == taxi.id end)
    end
  end

  describe "GET /index, when user is company" do
    setup [:authenticate_company]

    test "list all vouchers that belongs to the company", %{conn: conn, company: company} do
      company_employee = insert(:employee, %{company: company})
      insert_list(5, :voucher, %{employee: company_employee})
      insert_list(3, :voucher)

      conn = get(conn, Routes.voucher_path(conn, :index))

      company_vouchers = json_response(conn, 200)["data"]

      assert is_list(company_vouchers)
      assert Enum.count(company_vouchers) == 5
      assert Enum.all?(company_vouchers, fn voucher -> voucher["company"]["id"] == company.id end)
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
