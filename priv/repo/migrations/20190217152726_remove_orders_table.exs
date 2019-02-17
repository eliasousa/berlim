defmodule Berlim.Repo.Migrations.RemoveOrdersTable do
  use Ecto.Migration

  def change do
    drop table("orders")
  end
end
