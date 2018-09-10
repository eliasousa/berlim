defmodule Berlim.Repo.Migrations.CreateTaxis do
  use Ecto.Migration

  def change do
    create table(:taxis) do
      add(:email, :string, null: false)
      add(:password, :string, null: false)
      add(:active, :boolean, null: false)
      add(:phone, :string, null: false)
      add(:smtt, :integer, null: false, unique: true)
      add(:cpf, :string, null: false, unique: true)

      timestamps()
    end
  end
end
