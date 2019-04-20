defmodule Berlim.Repo.Migrations.CreateVouchers do
  use Ecto.Migration

  def change do
    create table(:vouchers) do
      add :value, :float, null: false
      add :from, :string, null: false
      add :to, :string, null: false
      add :km, :string
      add :note, :text
      add :payed_at, :utc_datetime
      add :taxi_id, references(:taxis, on_delete: :nothing), null: false
      add :employee_id, references(:employees, on_delete: :nothing), null: false
      add :payed_by_id, references(:admins, on_delete: :nothing)

      timestamps()
    end

    create index(:vouchers, [:taxi_id])
    create index(:vouchers, [:employee_id])
    create index(:vouchers, [:payed_by_id])
  end
end
