defmodule Berlim.Vouchers.Voucher do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Berlim.{
    CompanyAccounts.Employee,
    InternalAccounts.Taxi,
    InternalAccounts.Admin
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
    from v in query,
      join: e in assoc(v, :employee),
      where: e.company_id == ^company_id
  end

  def sorted_created_desc(query) do
    from v in query,
      order_by: [desc: v.inserted_at]
  end

  def with_associations(query) do
    from v in query,
      preload: [:taxi, :employee, employee: :company]
  end

  def query_filtered_by(query, filters) do
    Enum.reduce(filters, query, fn {key, value}, query ->
      case key do
        "created_start_at" ->
          from v in query,
            where: v.inserted_at >= ^value

        "created_end_at" ->
          from v in query,
            where: v.inserted_at <= ^value

        "payed_start_at" ->
          from v in query,
            where: v.payed_at >= ^value

        "payed_end_at" ->
          from v in query,
            where: v.payed_at <= ^value

        "company_id" ->
          belongs_to_company(query, value)

        "employee_id" ->
          from v in query,
            where: v.employee_id == ^value

        "taxi_id" ->
          belongs_to_taxi(query, value)

        _ ->
          query
      end
    end)
  end
end
