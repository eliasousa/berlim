defmodule BerlimWeb.Plugs.VoucherFiltersValidatorTest do
  use BerlimWeb.ConnCase, async: true

  import BerlimWeb.Plugs.VoucherFiltersValidator, only: [call: 2]
  import Berlim.Factory, only: [insert: 1]

  describe "user is authenticated as admin" do
    @valid_admin_voucher_filters ~w(payed_start_at payed_end_at created_start_at created_end_at
                           company_id employee_id taxi_id voucher_id)

    setup %{conn: conn} do
      conn = assign(conn, :admin, insert(:admin))

      %{conn: conn}
    end

    test "with valid params, assign only the valid admin filters to the conn", %{conn: conn} do
      conn =
        conn
        |> Map.put(:params, %{
          "payed_start_at" => "2019-07-04 00:00:00Z",
          "payed_end_at" => "2019-07-05 00:00:00Z",
          "created_start_at" => "2019-07-04 00:00:00Z",
          "created_end_at" => "2019-07-05 00:00:00Z",
          "taxi_id" => "1",
          "employee_id" => "1",
          "company_id" => "1",
          "voucher_id" => "1",
          "sector_id" => "1",
          "matricula" => "1234"
        })
        |> call(%{})

      assert conn.assigns.filters != []

      assert Enum.all?(conn.assigns.filters, fn {filter, _value} ->
               Enum.member?(@valid_admin_voucher_filters, filter)
             end)

      assert Enum.count(@valid_admin_voucher_filters) == Enum.count(conn.assigns.filters)
    end

    test "with invalid params, send error message with invalid parameters", %{conn: conn} do
      conn =
        conn
        |> Map.put(:params, %{
          "payed_start_at" => "20-07-04 00:00:00Z",
          "payed_end_at" => "20-07-05 00:00:00Z",
          "created_start_at" => "20-07-04 00:00:00Z",
          "created_end_at" => "20-07-05 00:00:00Z",
          "taxi_id" => "a1",
          "employee_id" => "a1",
          "company_id" => "a1",
          "voucher_id" => "a1"
        })
        |> call(%{})

      assert conn.status == 400
      assert conn.resp_body =~ "error"
      assert conn.resp_body =~ "Invalid created_start_at format"
      assert conn.resp_body =~ "Invalid created_end_at format"
      assert conn.resp_body =~ "Invalid payed_start_at format"
      assert conn.resp_body =~ "Invalid payed_end_at format"
      assert conn.resp_body =~ "Invalid company_id format"
      assert conn.resp_body =~ "Invalid employee_id format"
      assert conn.resp_body =~ "Invalid taxi_id format"
      assert conn.resp_body =~ "Invalid voucher_id format"
    end
  end

  describe "user is authenticated as taxi" do
    @valid_taxi_voucher_filters ~w(payed_start_at payed_end_at created_start_at created_end_at)

    setup %{conn: conn} do
      conn = assign(conn, :taxi, insert(:taxi))

      %{conn: conn}
    end

    test "assign only the valid taxi filters to the conn", %{conn: conn} do
      conn =
        conn
        |> Map.put(:params, %{
          "payed_start_at" => "2019-07-04 00:00:00Z",
          "payed_end_at" => "2019-07-05 00:00:00Z",
          "created_start_at" => "2019-07-04 00:00:00Z",
          "created_end_at" => "2019-07-05 00:00:00Z",
          "taxi_id" => "1",
          "employee_id" => "1",
          "company_id" => "1",
          "voucher_id" => "1",
          "sector_id" => "1",
          "matricula" => "1234"
        })
        |> call(%{})

      assert conn.assigns.filters != []

      assert Enum.all?(conn.assigns.filters, fn {filter, _value} ->
               Enum.member?(@valid_taxi_voucher_filters, filter)
             end)

      assert Enum.count(@valid_taxi_voucher_filters) == Enum.count(conn.assigns.filters)
    end

    test "with invalid params, send error message with invalid parameters", %{conn: conn} do
      conn =
        conn
        |> Map.put(:params, %{
          "payed_start_at" => "20-07-04 00:00:00Z",
          "payed_end_at" => "20-07-05 00:00:00Z",
          "created_start_at" => "20-07-04 00:00:00Z",
          "created_end_at" => "20-07-05 00:00:00Z"
        })
        |> call(%{})

      assert conn.status == 400
      assert conn.resp_body =~ "error"
      assert conn.resp_body =~ "Invalid created_start_at format"
      assert conn.resp_body =~ "Invalid created_end_at format"
      assert conn.resp_body =~ "Invalid payed_start_at format"
      assert conn.resp_body =~ "Invalid payed_end_at format"
    end
  end

  describe "user is authenticated as company" do
    @valid_company_voucher_filters ~w(payed_start_at payed_end_at created_start_at created_end_at employee_id
                              matricula sector_id)

    setup %{conn: conn} do
      conn = assign(conn, :company, insert(:company))

      %{conn: conn}
    end

    test "assign only the valid company filters to the conn", %{conn: conn} do
      conn =
        conn
        |> Map.put(:params, %{
          "payed_start_at" => "2019-04-07 00:00:00Z",
          "payed_end_at" => "2019-07-05 00:00:00Z",
          "created_start_at" => "2019-07-04 00:00:00Z",
          "created_end_at" => "2019-07-05 00:00:00Z",
          "employee_id" => "1",
          "matricula" => "1234",
          "sector_id" => "1",
          "taxi_id" => "1",
          "company_id" => "1",
          "voucher_id" => "1"
        })
        |> call(%{})

      assert conn.assigns.filters != []

      assert Enum.all?(conn.assigns.filters, fn {filter, _value} ->
               Enum.member?(@valid_company_voucher_filters, filter)
             end)

      assert Enum.count(@valid_company_voucher_filters) == Enum.count(conn.assigns.filters)
    end

    test "with invalid params, send error message with invalid parameters", %{conn: conn} do
      conn =
        conn
        |> Map.put(:params, %{
          "payed_start_at" => "20-07-04 00:00:00Z",
          "payed_end_at" => "20-07-05 00:00:00Z",
          "created_start_at" => "20-07-04 00:00:00Z",
          "created_end_at" => "20-07-05 00:00:00Z",
          "employee_id" => "a1",
          "sector_id" => "a1",
          "matricula" => 1
        })
        |> call(%{})

      assert conn.status == 400
      assert conn.resp_body =~ "error"
      assert conn.resp_body =~ "Invalid created_start_at format"
      assert conn.resp_body =~ "Invalid created_end_at format"
      assert conn.resp_body =~ "Invalid payed_start_at format"
      assert conn.resp_body =~ "Invalid payed_end_at format"
      assert conn.resp_body =~ "Invalid employee_id format"
      assert conn.resp_body =~ "Invalid sector_id format"
      assert conn.resp_body =~ "Invalid matricula format"
    end
  end

  test "filters assign is empty, if no param is given", %{conn: conn} do
    conn =
      conn
      |> Map.put(:params, %{})
      |> call(%{})

    assert conn.assigns.filters == []
  end
end
