defmodule BerlimWeb.OrderController do
  use BerlimWeb, :controller

  alias Berlim.{
    Sales,
    Sales.Order,
    Repo
  }

  def index(conn, params) do
    page = Sales.list_orders(params)
    orders = Repo.preload(page.entries, :taxi)

    render(conn, "index.html", orders: orders, page: page)
  end

  def new(conn, _params) do
    changeset = Sales.change_order(%Order{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    case Sales.create_order(order_params) do
      {:ok, _order} ->
        conn
        |> put_flash(:info, "Pagamento adicionado com sucesso.")
        |> redirect(to: Routes.order_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    order = Sales.get_order!(id)
    changeset = Sales.change_order(order)
    render(conn, "edit.html", order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Sales.get_order!(id)

    case Sales.update_order(order, order_params) do
      {:ok, _order} ->
        conn
        |> put_flash(:info, "Pagamento atualizado com sucesso.")
        |> redirect(to: Routes.order_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Sales.get_order!(id)
    {:ok, _order} = Sales.delete_order(order)

    conn
    |> put_flash(:info, "Pagamento deletado com sucesso.")
    |> redirect(to: Routes.order_path(conn, :index))
  end
end
