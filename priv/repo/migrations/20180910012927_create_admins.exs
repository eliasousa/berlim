defmodule Berlim.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add(:email, :string, null: false, unique: true)
      add(:password, :string, null: false)
      add(:name, :string, null: false)
      add(:active, :boolean, null: false)
      add(:phone, :string)

      timestamps()
    end
  end
end
