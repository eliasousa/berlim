defmodule Berlim.Repo.Migrations.UpdateTaxisTable do
  use Ecto.Migration

  def change do
    alter table(:taxis) do
      add :plan_id, references(:plans)
    end
  end
end
