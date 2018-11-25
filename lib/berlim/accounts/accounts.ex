defmodule Berlim.Accounts do

  import Ecto.Query

  alias Berlim.{
    Repo,
    Accounts.Taxi
  }

  def get_all_taxis do
    Repo.all(all_taxis_ordered_by_smtt())
  end

  def get_taxi_by_id(taxi_id) do
    Repo.get(Taxi, taxi_id)
  end

  def create_taxi(taxi) do
    taxi_changeset(taxi)
    |> Repo.insert
  end

  def taxi_changeset(changes \\ %{}) do
    Taxi.changeset(%Taxi{}, changes)
  end

  defp all_taxis_ordered_by_smtt do
    from Taxi,
      order_by: [asc: :smtt],
      select: [:id, :smtt]
  end
end
