# defmodule BerlimWeb.VoucherControllerTest do
#   use BerlimWeb.ConnCase

#   alias Berlim.Vouchers
#   alias Berlim.Vouchers.Voucher

#   @create_attrs %{
#     from: "some from",
#     km: "some km",
#     note: "some note",
#     payed_at: ~N[2010-04-17 14:00:00],
#     to: "some to",
#     value: 120.5
#   }
#   @update_attrs %{
#     from: "some updated from",
#     km: "some updated km",
#     note: "some updated note",
#     payed_at: ~N[2011-05-18 15:01:01],
#     to: "some updated to",
#     value: 456.7
#   }
#   @invalid_attrs %{from: nil, km: nil, note: nil, payed_at: nil, to: nil, value: nil}

#   def fixture(:voucher) do
#     {:ok, voucher} = Vouchers.create_voucher(@create_attrs)
#     voucher
#   end

#   setup %{conn: conn} do
#     {:ok, conn: put_req_header(conn, "accept", "application/json")}
#   end

#   describe "index" do
#     test "lists all vouchers", %{conn: conn} do
#       conn = get(conn, Routes.voucher_path(conn, :index))
#       assert json_response(conn, 200)["data"] == []
#     end
#   end

#   describe "create voucher" do
#     test "renders voucher when data is valid", %{conn: conn} do
#       conn = post(conn, Routes.voucher_path(conn, :create), voucher: @create_attrs)
#       assert %{"id" => id} = json_response(conn, 201)["data"]

#       conn = get(conn, Routes.voucher_path(conn, :show, id))

#       assert %{
#                "id" => id,
#                "from" => "some from",
#                "km" => "some km",
#                "note" => "some note",
#                "payed_at" => "2010-04-17T14:00:00",
#                "to" => "some to",
#                "value" => 120.5
#              } = json_response(conn, 200)["data"]
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, Routes.voucher_path(conn, :create), voucher: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end

#   describe "update voucher" do
#     setup [:create_voucher]

#     test "renders voucher when data is valid", %{conn: conn, voucher: %Voucher{id: id} = voucher} do
#       conn = put(conn, Routes.voucher_path(conn, :update, voucher), voucher: @update_attrs)
#       assert %{"id" => ^id} = json_response(conn, 200)["data"]

#       conn = get(conn, Routes.voucher_path(conn, :show, id))

#       assert %{
#                "id" => id,
#                "from" => "some updated from",
#                "km" => "some updated km",
#                "note" => "some updated note",
#                "payed_at" => "2011-05-18T15:01:01",
#                "to" => "some updated to",
#                "value" => 456.7
#              } = json_response(conn, 200)["data"]
#     end

#     test "renders errors when data is invalid", %{conn: conn, voucher: voucher} do
#       conn = put(conn, Routes.voucher_path(conn, :update, voucher), voucher: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end

#   describe "delete voucher" do
#     setup [:create_voucher]

#     test "deletes chosen voucher", %{conn: conn, voucher: voucher} do
#       conn = delete(conn, Routes.voucher_path(conn, :delete, voucher))
#       assert response(conn, 204)

#       assert_error_sent 404, fn ->
#         get(conn, Routes.voucher_path(conn, :show, voucher))
#       end
#     end
#   end

#   defp create_voucher(_) do
#     voucher = fixture(:voucher)
#     {:ok, voucher: voucher}
#   end
# end
