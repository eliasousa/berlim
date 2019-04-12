defmodule Berlim.Repo.Migrations.AddEmailToEmployees do
  use Ecto.Migration

  def change do
    alter table(:employees) do
      add :email, :citext, null: false, unique: true
    end

    create unique_index(:employees, [:email])
  end
end
