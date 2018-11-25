defmodule BerlimWeb.AdminController do
  use BerlimWeb, :controller

  alias Berlim.Accounts
  alias Berlim.Accounts.Admin

  def index(conn, _params) do
    admins = Accounts.list_admins()
    render(conn, "index.html", admins: admins)
  end

  def new(conn, _params) do
    changeset = Accounts.change_admin(%Admin{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"admin" => admin_params}) do
    case Accounts.create_admin(admin_params) do
      {:ok, _admin} ->
        conn
        |> put_flash(:info, "Admin adicionado com sucesso.")
        |> redirect(to: Routes.admin_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    admin = Accounts.get_admin!(id)
    changeset = Accounts.change_admin(admin)
    render(conn, "edit.html", admin: admin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "admin" => admin_params}) do
    admin = Accounts.get_admin!(id)

    case Accounts.update_admin(admin, admin_params) do
      {:ok, _admin} ->
        conn
        |> put_flash(:info, "Admin atualizado com sucesso.")
        |> redirect(to: Routes.admin_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", admin: admin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin = Accounts.get_admin!(id)
    {:ok, _admin} = Accounts.delete_admin(admin)

    conn
    |> put_flash(:info, "Admin deletado com sucesso.")
    |> redirect(to: Routes.admin_path(conn, :index))
  end
end
