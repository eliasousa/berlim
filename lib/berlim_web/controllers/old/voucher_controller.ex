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
end
