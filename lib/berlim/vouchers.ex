defmodule Berlim.Vouchers do
  @moduledoc """
  The Vouchers context.
  """

  import Ecto.Query, warn: false
  alias Berlim.Repo

  alias Berlim.Vouchers.Voucher

  @doc """
  Returns the list of vouchers.

  ## Examples

      iex> list_vouchers()
      [%Voucher{}, ...]

  """
  def list_vouchers do
    Repo.all(Voucher)
  end

  @doc """
  Gets a single voucher.

  Raises `Ecto.NoResultsError` if the Voucher does not exist.

  ## Examples

      iex> get_voucher!(123)
      %Voucher{}

      iex> get_voucher!(456)
      ** (Ecto.NoResultsError)

  """
  def get_voucher!(id), do: Repo.get!(Voucher, id)

  @doc """
  Creates a voucher.

  ## Examples

      iex> create_voucher(%{field: value})
      {:ok, %Voucher{}}

      iex> create_voucher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_voucher(attrs \\ %{}) do
    %Voucher{}
    |> Voucher.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a voucher.

  ## Examples

      iex> update_voucher(voucher, %{field: new_value})
      {:ok, %Voucher{}}

      iex> update_voucher(voucher, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_voucher(%Voucher{} = voucher, attrs) do
    voucher
    |> Voucher.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Voucher.

  ## Examples

      iex> delete_voucher(voucher)
      {:ok, %Voucher{}}

      iex> delete_voucher(voucher)
      {:error, %Ecto.Changeset{}}

  """
  def delete_voucher(%Voucher{} = voucher) do
    Repo.delete(voucher)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking voucher changes.

  ## Examples

      iex> change_voucher(voucher)
      %Ecto.Changeset{source: %Voucher{}}

  """
  def change_voucher(%Voucher{} = voucher) do
    Voucher.changeset(voucher, %{})
  end
end
