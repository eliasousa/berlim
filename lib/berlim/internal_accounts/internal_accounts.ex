defmodule Berlim.InternalAccounts do
  @moduledoc """
  The InternalAccounts context.
  """

  alias Berlim.{Email, InternalAccounts.Admin, InternalAccounts.Taxi, Mailer, Repo}

  def list_admins, do: Repo.all(Admin)

  def get_admin!(id), do: Repo.get!(Admin, id)

  def create_admin(attrs \\ %{}) do
    %Admin{}
    |> Admin.changeset(attrs)
    |> Repo.insert()
  end

  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.changeset(attrs)
    |> Repo.update()
  end

  def delete_admin(%Admin{} = admin) do
    Repo.delete(admin)
  end

  def change_admin(%Admin{} = admin) do
    Admin.changeset(admin, %{})
  end

  def list_taxis, do: Repo.all(Taxi)

  def get_taxi!(id), do: Repo.get!(Taxi, id)

  def create_taxi(taxi_attrs) do
    changeset = change_taxi(%Taxi{}, taxi_attrs)

    with {:ok, taxi} <- Repo.insert(changeset) do
      taxi.email
      |> Email.welcome(taxi.smtt, get_password(taxi_attrs))
      |> Mailer.deliver()

      {:ok, taxi}
    end
  end

  def update_taxi(taxi, taxi_attrs) do
    taxi
    |> change_taxi(taxi_attrs)
    |> Repo.update()
  end

  def change_taxi(taxi \\ %Taxi{}, taxi_attrs \\ %{}) do
    Taxi.changeset(taxi, taxi_attrs)
  end

  defp get_password(%{"encrypted_password" => password}), do: password
  defp get_password(%{encrypted_password: password}), do: password
end
