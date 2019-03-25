defmodule Berlim.Repo.Migrations.CreateSectors do
  use Ecto.Migration

  def change do
    create table(:sectors) do
      add :name, :string, null: false
      add :company_id, references(:companies, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:sectors, [:company_id])
  end
end
