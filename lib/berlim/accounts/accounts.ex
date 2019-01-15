defmodule Berlim.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, only: [order_by: 2]

  alias Berlim.{
    Repo,
    Accounts.Admin,
    Accounts.Taxi
  }

  alias Comeonin.Bcrypt

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

  def list_taxis(params) do
    Taxi
    |> order_by(asc: :smtt)
    |> Repo.paginate(params)
  end

  def get_taxi!(taxi_id) do
    Repo.get!(Taxi, taxi_id)
  end

  def create_taxi(taxi_attrs) do
    %Taxi{}
    |> change_taxi(taxi_attrs)
    |> Repo.insert()
  end

  def update_taxi(taxi, taxi_attrs) do
    taxi
    |> change_taxi(taxi_attrs)
    |> Repo.update()
  end

  def change_taxi(taxi \\ %Taxi{}, taxi_attrs \\ %{}) do
    Taxi.changeset(taxi, taxi_attrs)
  end

  def authenticate_user(%{"email" => email, "password" => password})
      when email !== "" and password !== "" do
    cond do
      admin = Repo.get_by(Admin, email: email) ->
        admin

      taxi = Repo.get_by(Taxi, email: email) ->
        taxi

      true ->
        nil
    end
    |> Bcrypt.check_pass(password)
  end

  def authenticate_user(_empty_params), do: {:error, "empty params"}
end
