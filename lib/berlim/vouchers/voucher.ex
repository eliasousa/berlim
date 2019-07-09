defmodule Berlim.Vouchers.Voucher do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query,
    only: [
      from: 2,
      has_named_binding?: 2,
      where: 3,
      join: 5
    ]

  alias Berlim.{
    CompanyAccounts.Employee,
    InternalAccounts.Admin,
    InternalAccounts.Taxi
  }

  @timestamps_opts [type: :utc_datetime]

  schema "vouchers" do
    field :from, :string
    field :km, :string
    field :note, :string
    field :to, :string
    field :value, :float
    field :payed_at, :utc_datetime
    belongs_to :employee, Employee
    belongs_to :taxi, Taxi
    belongs_to :payed_by, Admin, foreign_key: :payed_by_id

    timestamps()
  end

  @doc false
  def changeset(voucher, admin, attrs) do
    voucher
    |> default_changeset(attrs)
    |> put_assoc(:payed_by, admin)
  end

  @doc false
  def changeset(voucher, attrs) do
    default_changeset(voucher, attrs)
  end

  defp default_changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:from, :km, :note, :to, :value, :payed_at, :employee_id, :taxi_id])
    |> validate_required([:value, :from, :to, :taxi_id, :employee_id])
    |> foreign_key_constraint(:taxi_id)
    |> foreign_key_constraint(:employee_id)
  end

  def belongs_to_taxi(query, taxi_id) do
    from v in query,
      where: v.taxi_id == ^taxi_id
  end

  def belongs_to_company(query, company_id) do
    query
    |> join_employees_if_not_bound()
    |> where([v, e], e.company_id == ^company_id)
  end

  def sorted_created_desc(query) do
    from v in query,
      order_by: [desc: v.inserted_at]
  end

  def with_associations(query) do
    from v in query,
      preload: [:taxi, employee: [:company, :sector]]
  end

  def query_filtered_by(query, filters) do
    Enum.reduce(filters, query, fn {key, value}, query ->
      filter_by({key, value}, query)
    end)
  end

  defp filter_by({"created_start_at", value}, query) do
    from v in query,
      where: v.inserted_at >= ^value
  end

  defp filter_by({"created_end_at", value}, query) do
    from v in query,
      where: v.inserted_at <= ^value
  end

  defp filter_by({"payed_start_at", value}, query) do
    from v in query,
      where: v.payed_at >= ^value
  end

  defp filter_by({"payed_end_at", value}, query) do
    from v in query,
      where: v.payed_at <= ^value
  end

  defp filter_by({"company_id", value}, query) do
    belongs_to_company(query, value)
  end

  defp filter_by({"taxi_id", value}, query) do
    belongs_to_taxi(query, value)
  end

  defp filter_by({"employee_id", value}, query) do
    from v in query,
      where: v.employee_id == ^value
  end

  defp filter_by({"matricula", value}, query) do
    query
    |> join_employees_if_not_bound()
    |> where([v, e], e.internal_id == ^value)
  end

  defp filter_by({"sector_id", value}, query) do
    query
    |> join_employees_if_not_bound()
    |> where([v, e], e.sector_id == ^value)
  end

  defp filter_by({"voucher_id", value}, query) do
    from v in query,
      where: v.id == ^value
  end

  defp filter_by(_, query) do
    query
  end

  defp join_employees_if_not_bound(queryable) do
    if has_named_binding?(queryable, :employees) do
      queryable
    else
      join(queryable, :inner, [voucher], e in assoc(voucher, :employee),
        as: :employees,
        on: voucher.employee_id == e.id
      )
    end
  end
end
