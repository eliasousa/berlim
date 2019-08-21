defmodule Berlim.Vouchers do
  @moduledoc """
  The Vouchers context.
  """

  import Ecto.Query,
    only: [
      from: 2,
      has_named_binding?: 2,
      where: 3,
      join: 5
    ]

  alias Berlim.{
    CompanyAccounts.Company,
    EmailGenerator,
    InternalAccounts.Admin,
    InternalAccounts.Taxi,
    Mailer,
    Repo,
    Vouchers.Voucher
  }

  def list_vouchers(filters \\ []) do
    Voucher
    |> query_filtered_by(filters)
    |> sorted_created_desc()
    |> with_associations()
    |> Repo.all()
  end

  def list_taxi_vouchers(%Taxi{} = taxi, filters \\ []) do
    Voucher
    |> belongs_to_taxi(taxi.id)
    |> query_filtered_by(filters)
    |> sorted_created_desc()
    |> with_associations()
    |> Repo.all()
  end

  def list_company_vouchers(%Company{} = company, filters \\ []) do
    Voucher
    |> belongs_to_company(company.id)
    |> query_filtered_by(filters)
    |> sorted_created_desc()
    |> with_associations()
    |> Repo.all()
  end

  def get_voucher!(id) do
    Voucher
    |> with_associations()
    |> Repo.get!(id)
  end

  def create_voucher(attrs) do
    changeset = change_voucher(%Voucher{}, attrs)

    with {:ok, voucher} <- Repo.insert(changeset) do
      voucher = Repo.preload(voucher, [:taxi, employee: [:company, :sector]])

      send_voucher_receipt(voucher.taxi.email, voucher)
      send_voucher_receipt(voucher.employee.email, voucher)
      send_voucher_receipt(voucher.employee.company.email, voucher)

      {:ok, voucher}
    end
  end

  def pay_vouchers(ids, %Admin{} = paid_by) do
    query = from v in Voucher, where: v.id in ^ids, select: v.value
    now = DateTime.utc_now()

    with {_count, values} <-
           Repo.update_all(query, set: [paid_at: now, updated_at: now, paid_by_id: paid_by.id]) do
      total_paid = :erlang.float_to_binary(Enum.sum(values), decimals: 1)
      {:ok, total_paid}
    end
  end

  def change_voucher(voucher \\ %Voucher{}, voucher_attrs \\ %{}) do
    Voucher.changeset(voucher, voucher_attrs)
  end

  defp send_voucher_receipt(email, voucher) do
    email |> EmailGenerator.voucher_receipt(voucher) |> Mailer.deliver()
  end

  defp belongs_to_taxi(query, taxi_id) do
    from v in query,
      where: v.taxi_id == ^taxi_id
  end

  defp belongs_to_company(query, company_id) do
    query
    |> join_employees_if_not_bound()
    |> where([v, e], e.company_id == ^company_id)
  end

  defp sorted_created_desc(query) do
    from v in query,
      order_by: [desc: v.inserted_at]
  end

  defp with_associations(query) do
    from v in query,
      preload: [:taxi, employee: [:company, :sector]]
  end

  defp query_filtered_by(query, filters) do
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

  defp filter_by({"paid_start_at", value}, query) do
    from v in query,
      where: v.paid_at >= ^value
  end

  defp filter_by({"paid_end_at", value}, query) do
    from v in query,
      where: v.paid_at <= ^value
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
