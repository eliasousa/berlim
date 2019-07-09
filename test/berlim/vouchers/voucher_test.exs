defmodule Berlim.Vouchers.VoucherTest do
  use Berlim.DataCase, async: true
  use Timex

  import Berlim.Factory

  alias Berlim.Vouchers.Voucher

  @date Timex.to_datetime({{2019, 6, 7}, {0, 0, 0}})

  test "changeset/2 with valid attributes" do
    changeset = Voucher.changeset(%Voucher{}, voucher_params())
    assert changeset.valid?
  end

  test "changeset/2 with invalid attributes" do
    changeset = Voucher.changeset(%Voucher{}, %{})
    refute changeset.valid?
  end

  test "changeset/3 with valid attributes" do
    changeset = Voucher.changeset(%Voucher{}, insert(:admin), voucher_params())
    assert changeset.valid?
  end

  test "changeset/3 with invalid attributes" do
    changeset = Voucher.changeset(%Voucher{}, insert(:admin), %{})
    refute changeset.valid?
  end

  test "taxi does not exist" do
    voucher = Voucher.changeset(%Voucher{}, %{voucher_params() | taxi_id: 0})
    assert {:error, changeset} = Repo.insert(voucher)
    assert %{taxi_id: ["does not exist"]} = errors_on(changeset)
  end

  test "employee does not exist" do
    voucher = Voucher.changeset(%Voucher{}, %{voucher_params() | employee_id: 0})
    assert {:error, changeset} = Repo.insert(voucher)
    assert %{employee_id: ["does not exist"]} = errors_on(changeset)
  end

  test "belongs_to_taxi/2, builds a query that filters the vouchers that belongs to a taxi" do
    expected_query =
      from v in Voucher,
        where: v.taxi_id == ^1

    query_result = Voucher.belongs_to_taxi(Voucher, 1)

    assert inspect(expected_query) == inspect(query_result)
  end

  test "belongs_to_company/2, builds a query that filters the vouchers that belongs to a company" do
    expected_query =
      from v in Voucher,
        join: e in assoc(v, :employee),
        as: :employees,
        on: v.employee_id == e.id,
        where: e.company_id == ^1

    query_result = Voucher.belongs_to_company(Voucher, 1)

    assert inspect(expected_query) == inspect(query_result)
  end

  test "sorted_created_desc/1, builds a query that sorts vouchers from the most recent to the oldest" do
    expected_query =
      from v in Voucher,
        order_by: [desc: v.inserted_at]

    query_result = Voucher.sorted_created_desc(Voucher)

    assert inspect(expected_query) == inspect(query_result)
  end

  test "with_associations/1, builds a query that preload the voucher associations,
       :taxi, :employee and the nested association: employee: :company" do
    expected_query =
      from v in Voucher,
        preload: [:taxi, employee: [:company, :sector]]

    query_result = Voucher.with_associations(Voucher)

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with payed_start_at filter,
        builds a query that filters the vouchers that were paid during or after a date" do
    expected_query =
      from v in Voucher,
        where: v.payed_at >= ^@date

    query_result = Voucher.query_filtered_by(Voucher, [{"payed_start_at", @date}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with payed_end_at filter,
        builds a query that filters the vouchers that were paid before or during a date" do
    expected_query =
      from v in Voucher,
        where: v.payed_at <= ^@date

    query_result = Voucher.query_filtered_by(Voucher, [{"payed_end_at", @date}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with created_start_at filter,
        builds a query that filters the vouchers that were created during or after a date" do
    expected_query =
      from v in Voucher,
        where: v.inserted_at >= ^@date

    query_result = Voucher.query_filtered_by(Voucher, [{"created_start_at", @date}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with created_end_at filter,
        builds a query that filters the vouchers that were created before or during a date" do
    expected_query =
      from v in Voucher,
        where: v.inserted_at <= ^@date

    query_result = Voucher.query_filtered_by(Voucher, [{"created_end_at", @date}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with company_id filter,
        builds a query that filters the vouchers that belongs to a company" do
    expected_query =
      from v in Voucher,
        join: e in assoc(v, :employee),
        as: :employees,
        on: v.employee_id == e.id,
        where: e.company_id == ^1

    query_result = Voucher.query_filtered_by(Voucher, [{"company_id", 1}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with employee_id filter,
        builds a query that filters the vouchers that belongs to a employee" do
    expected_query =
      from v in Voucher,
        where: v.employee_id == ^1

    query_result = Voucher.query_filtered_by(Voucher, [{"employee_id", 1}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with taxi_id filter,
        builds a query that filters the vouchers that belongs to a taxi" do
    expected_query =
      from v in Voucher,
        where: v.taxi_id == ^1

    query_result = Voucher.query_filtered_by(Voucher, [{"taxi_id", 1}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with matricula filter,
        builds a query that filters the vouchers that belongs to a employee" do
    expected_query =
      from v in Voucher,
        join: e in assoc(v, :employee),
        as: :employees,
        on: v.employee_id == e.id,
        where: e.internal_id == ^"1"

    query_result = Voucher.query_filtered_by(Voucher, [{"matricula", "1"}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with sector_id filter,
        builds a query that filters the vouchers that belongs to a sector" do
    expected_query =
      from v in Voucher,
        join: e in assoc(v, :employee),
        as: :employees,
        on: v.employee_id == e.id,
        where: e.sector_id == ^1

    query_result = Voucher.query_filtered_by(Voucher, [{"sector_id", 1}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with voucher_id filter,
        builds a query that filters a voucher" do
    expected_query =
      from v in Voucher,
        where: v.id == ^1

    query_result = Voucher.query_filtered_by(Voucher, [{"voucher_id", 1}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with all filters above,
        builds a query that filters the vouchers using all of the above filters" do
    expected_query =
      from v in Voucher,
        join: e in assoc(v, :employee),
        as: :employees,
        on: v.employee_id == e.id,
        where: v.payed_at >= ^@date,
        where: v.payed_at <= ^@date,
        where: v.inserted_at >= ^@date,
        where: v.inserted_at <= ^@date,
        where: e.company_id == ^1,
        where: v.employee_id == ^1,
        where: v.taxi_id == ^1,
        where: e.internal_id == ^"1",
        where: e.sector_id == ^1,
        where: v.id == ^1

    query_result =
      Voucher.query_filtered_by(Voucher, [
        {"payed_start_at", @date},
        {"payed_end_at", @date},
        {"created_start_at", @date},
        {"created_end_at", @date},
        {"company_id", 1},
        {"employee_id", 1},
        {"taxi_id", 1},
        {"matricula", "1"},
        {"sector_id", 1},
        {"voucher_id", 1}
      ])

    assert inspect(expected_query) == inspect(query_result)
  end

  defp voucher_params do
    params_with_assocs(:voucher)
  end
end
