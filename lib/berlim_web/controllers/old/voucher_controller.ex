defmodule BerlimWeb.Old.VoucherController do
  use BerlimWeb, :controller

  alias Bcrypt
  alias Berlim.{Repo, Vouchers.Voucher}
  import Ecto.Query, only: [from: 2]

  def index(conn, %{"id" => taxi_id}) do
    query = from v in Voucher, where: v.taxi_id == ^taxi_id and is_nil(v.payed_at)

    case query |> Repo.all() |> Repo.preload(employee: [:company]) do
      [%Voucher{} | _] = vouchers ->
        render(conn, "index.json", vouchers: vouchers)

      _ ->
        json(conn, false)
    end
  end

  def create(conn, %{"voucher" => voucher_params}) do
    case create_old_voucher(voucher_params) do
      {:ok, %Voucher{} = voucher} ->
        json(conn, %{id: voucher.id})

      _ ->
        json(conn, false)
    end
  end

  defp create_old_voucher(old_voucher_attrs) do
    new_voucher_attrs = old_to_new_voucher_attrs(old_voucher_attrs)

    %Voucher{}
    |> Voucher.changeset(new_voucher_attrs)
    |> Repo.insert()
  end

  defp old_to_new_voucher_attrs(voucher_attrs) do
    Map.new(
      from: Map.get(voucher_attrs, "saida"),
      to: Map.get(voucher_attrs, "chegada"),
      value: Map.get(voucher_attrs, "valor"),
      employee_id: Map.get(voucher_attrs, "funcionario_id"),
      taxi_id: Map.get(voucher_attrs, "taxista_id"),
      km: Map.get(voucher_attrs, "km"),
      note: Map.get(voucher_attrs, "obs")
    )
  end
end
