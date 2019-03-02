defmodule Berlim.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string, null: false
      add :cnpj, :string, null: false, unique: true
      add :email, :string, null: false, unique: true
      add :encrypted_password, :string, null: false
      add :active, :boolean, default: true, null: false
      add :phone, :string

      timestamps()
    end

    create unique_index(:companies, [:email])
    create unique_index(:companies, [:cnpj])
  end
end
