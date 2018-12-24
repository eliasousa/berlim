defmodule Berlim.Repo.Migrations.AddCustomerToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :customer, :map
    end
  end
end
