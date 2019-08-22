defmodule Berlim.Repo.Migrations.RenamePayedAtColumn do
  use Ecto.Migration

  def change do
    rename table(:vouchers), :payed_at, to: :paid_at
    rename table(:vouchers), :payed_by_id, to: :paid_by_id
  end
end
