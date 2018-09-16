defmodule Berlim.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:value, :float, null: false)
      add(:status, :string, null: false)
      add(:type, :string, null: false)
      add(:approved_at, :utc_datetime)
      add(:monthly_date, :date, null: false)
      add(:taxi_id, references(:taxis, on_delete: :nothing), null: false)
      add(:customer_id, references(:customers, on_delete: :nothing), null: false)

      timestamps()
    end

    create(index(:orders, [:taxi_id]))
    create(index(:orders, [:customer_id]))
  end
end
