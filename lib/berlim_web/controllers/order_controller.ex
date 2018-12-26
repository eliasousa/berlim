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

  # def edit(conn, %{"id" => id}) do
  #   admin = Accounts.get_admin!(id)
  #   changeset = Accounts.change_admin(admin)
  #   render(conn, "edit.html", admin: admin, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "admin" => admin_params}) do
  #   admin = Accounts.get_admin!(id)

  #   case Accounts.update_admin(admin, admin_params) do
  #     {:ok, _admin} ->
  #       conn
  #       |> put_flash(:info, "Admin atualizado com sucesso.")
  #       |> redirect(to: Routes.admin_path(conn, :index))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", admin: admin, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   admin = Accounts.get_admin!(id)
  #   {:ok, _admin} = Accounts.delete_admin(admin)

  #   conn
  #   |> put_flash(:info, "Admin deletado com sucesso.")
  #   |> redirect(to: Routes.admin_path(conn, :index))
  # end
end
