defmodule BerlimWeb.AdminController do
  use BerlimWeb, :controller

  alias Berlim.InternalAccounts
  alias Berlim.InternalAccounts.Admin

  action_fallback(BerlimWeb.FallbackController)

  def index(conn, _params) do
    admins = InternalAccounts.list_admins()
    render(conn, "index.json", admins: admins)
  end

  def create(conn, %{"admin" => admin_params}) do
    with {:ok, %Admin{} = admin} <- InternalAccounts.create_admin(admin_params) do
      conn
      |> put_status(:created)
      |> render("show.json", admin: admin)
    end
  end

  def show(conn, %{"id" => id}) do
    admin = InternalAccounts.get_admin!(id)
    render(conn, "show.json", admin: admin)
  end

  def update(conn, %{"id" => id, "admin" => admin_params}) do
    admin = InternalAccounts.get_admin!(id)

    with {:ok, %Admin{} = admin} <- InternalAccounts.update_admin(admin, admin_params) do
      render(conn, "show.json", admin: admin)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin = InternalAccounts.get_admin!(id)

    with {:ok, %Admin{}} <- InternalAccounts.delete_admin(admin) do
      send_resp(conn, :no_content, "")
    end
  end
end
