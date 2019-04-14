defmodule Berlim.Repo.Migrations.AddEmailToEmployees do
  use Ecto.Migration

  def change do
    alter table(:employees) do
      add :email, :citext, null: false, unique: true
      add :encrypted_password, :string, null: false
    end

    create unique_index(:employees, [:email])
  end
end
