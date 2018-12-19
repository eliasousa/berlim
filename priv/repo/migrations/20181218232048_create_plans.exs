defmodule Berlim.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add(:name, :string, null: false)
      add(:value, :float, null: false)

      timestamps()
    end
  end
end
