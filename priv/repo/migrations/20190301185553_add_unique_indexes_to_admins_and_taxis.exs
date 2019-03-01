defmodule Berlim.Repo.Migrations.AddUniqueIndexesToAdminsAndTaxis do
  use Ecto.Migration

  def change do
    create unique_index(:admins, [:email])
    create unique_index(:taxis, [:email])
    create unique_index(:taxis, [:smtt])
  end
end
