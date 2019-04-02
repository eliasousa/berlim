defmodule Berlim.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :name, :string, null: false
      add :internal_id, :string
      add :active, :boolean, default: true, null: false
      add :company_id, references(:companies, on_delete: :delete_all), null: false
      add :sector_id, references(:sectors, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:employees, [:company_id])
    create index(:employees, [:sector_id])
  end
end
