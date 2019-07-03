defmodule Berlim.Vouchers.VoucherTest do
  use Berlim.DataCase, async: true
  use Timex

  import Berlim.Factory

  alias Berlim.Vouchers.Voucher

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
        preload: [:taxi, employee: :company]

    query_result = Voucher.with_associations(Voucher)

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with payed_start_at filter,
        builds a query that filters the vouchers that were paid during or after a date" do
    date = Timex.to_datetime({{2019, 6, 7}, {0, 0, 0}})

    expected_query =
      from v in Voucher,
        where: v.payed_at >= ^date

    query_result = Voucher.query_filtered_by(Voucher, [{"payed_start_at", date}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with payed_end_at filter,
        builds a query that filters the vouchers that were paid before or during a date" do
    date = Timex.to_datetime({{2019, 6, 7}, {0, 0, 0}})

    expected_query =
      from v in Voucher,
        where: v.payed_at <= ^date

    query_result = Voucher.query_filtered_by(Voucher, [{"payed_end_at", date}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with created_start_at filter,
        builds a query that filters the vouchers that were created during or after a date" do
    date = Timex.to_datetime({{2019, 6, 7}, {0, 0, 0}})

    expected_query =
      from v in Voucher,
        where: v.inserted_at >= ^date

    query_result = Voucher.query_filtered_by(Voucher, [{"created_start_at", date}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with created_end_at filter,
        builds a query that filters the vouchers that were created before or during a date" do
    date = Timex.to_datetime({{2019, 6, 7}, {0, 0, 0}})

    expected_query =
      from v in Voucher,
        where: v.inserted_at <= ^date

    query_result = Voucher.query_filtered_by(Voucher, [{"created_end_at", date}])

    assert inspect(expected_query) == inspect(query_result)
  end

  test "query_filtered_by/2 with company_id filter,
        builds a query that filters the vouchers that belongs to a company" do
    expected_query =
      from v in Voucher,
        join: e in assoc(v, :employee),
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

  test "query_filtered_by/2 with all filters above,
        builds a query that filters the vouchers using all of the above filters" do
    date = Timex.to_datetime({{2019, 6, 7}, {0, 0, 0}})

    expected_query =
      from v in Voucher,
        join: e in assoc(v, :employee),
        where: v.payed_at >= ^date,
        where: v.payed_at <= ^date,
        where: v.inserted_at >= ^date,
        where: v.inserted_at <= ^date,
        where: e.company_id == ^1,
        where: v.employee_id == ^1,
        where: v.taxi_id == ^1

    query_result =
      Voucher.query_filtered_by(Voucher, [
        {"payed_start_at", date},
        {"payed_end_at", date},
        {"created_start_at", date},
        {"created_end_at", date},
        {"company_id", 1},
        {"employee_id", 1},
        {"taxi_id", 1}
      ])

    assert inspect(expected_query) == inspect(query_result)
  end

  defp voucher_params do
    params_with_assocs(:voucher)
  end
end
