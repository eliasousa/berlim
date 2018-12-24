defmodule Berlim.Repo.Migrations.DropCustomersTable do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      remove :customer_id
    end

    drop table(:customers)
  end
end
