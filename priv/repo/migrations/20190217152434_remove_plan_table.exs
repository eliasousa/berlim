defmodule Berlim.Repo.Migrations.RemovePlanTable do
  use Ecto.Migration

  def change do
    alter table("taxis") do
      remove :plan_id
    end

    drop table("plans")
  end
end
