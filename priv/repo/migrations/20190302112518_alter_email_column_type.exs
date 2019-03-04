defmodule Berlim.Repo.Migrations.AlterEmailColumnType do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext")

    alter table(:admins) do
      modify :email, :citext
    end

    alter table(:taxis) do
      modify :email, :citext
    end

    alter table(:companies) do
      modify :email, :citext
    end
  end
end
