defmodule Berlim.Repo.Migrations.AlterPasswordColumnName do
  use Ecto.Migration

  def change do
    rename table(:admins), :password, to: :encrypted_password
    rename table(:taxis), :password, to: :encrypted_password
  end
end
