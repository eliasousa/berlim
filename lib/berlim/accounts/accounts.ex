defmodule Berlim.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Berlim.Repo

  alias Berlim.Accounts.Admin

  def list_admins do
    Repo.all(Admin)
  end

  def get_admin!(id), do: Repo.get!(Admin, id)

  def create_admin(attrs \\ %{}) do
    %Admin{}
    |> Admin.changeset(attrs)
    |> Repo.insert()
  end

  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.changeset(attrs)
    |> Repo.update()
  end

  def delete_admin(%Admin{} = admin) do
    Repo.delete(admin)
  end

  def change_admin(%Admin{} = admin) do
    Admin.changeset(admin, %{})
  end
end
