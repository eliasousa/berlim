defmodule Berlim.SalesTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.Sales

  describe "plans" do
    alias Berlim.Sales.Plan

    @valid_attrs params_for(:plan)
    @update_attrs %{name: "Especial", value: 150}
    @invalid_attrs %{name: nil, value: nil}

    test "list_plans/0 returns all plans" do
      plan = insert(:plan)
      assert Sales.list_plans() == [plan]
    end

    test "get_plan!/1 returns the plan with given id" do
      plan = insert(:plan)
      assert Sales.get_plan!(plan.id) == plan
    end

    test "create_plan/1 with valid data creates a plan" do
      assert {:ok, %Plan{} = plan} = Sales.create_plan(@valid_attrs)
      assert plan.name == "Aracaju"
      assert plan.value == 200
    end

    test "create_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_plan(@invalid_attrs)
    end

    test "update_plan/2 with valid data updates the plan" do
      plan = insert(:plan)
      assert {:ok, %Plan{} = plan} = Sales.update_plan(plan, @update_attrs)
      assert plan.name == "Especial"
      assert plan.value == 150
    end

    test "update_plan/2 with invalid data returns error changeset" do
      plan = insert(:plan)
      assert {:error, %Ecto.Changeset{}} = Sales.update_plan(plan, @invalid_attrs)
      assert plan == Sales.get_plan!(plan.id)
    end

    test "change_plan/1 returns a plan changeset" do
      plan = insert(:plan)
      assert %Ecto.Changeset{} = Sales.change_plan(plan)
    end
  end

  describe "orders" do
    alias Berlim.Sales.Order

    test "list_orders/1 returns the first 30 orders ordered desc by inserted_at" do
      insert_list(45, :order)
      page = Sales.list_orders(%{page: 1})

      assert is_list(page.entries)
      assert Enum.count(page.entries) == 30
      assert page.total_entries == 45
      assert page.total_pages == 2
    end

    test "get_order!/1 returns the order with given id" do
      order = insert(:order)
      assert Sales.get_order!(order.id).id == order.id
    end

    test "create_order/1 with valid data creates a order" do
      taxi = insert(:taxi)
      taxi = Repo.preload(taxi, :plan)

      create_attrs = %{"monthly_date" => "25/10/2018", "taxi_id" => taxi.id}

      assert {:ok, %Order{} = order} = Sales.create_order(create_attrs)
      assert order.status == :paid
      assert order.type == :money
      assert order.monthly_date == ~D[2018-10-25]
      assert order.value == taxi.plan.value
    end

    test "update_order/2 with valid data updates the order" do
      order = insert(:order)

      taxi = insert(:taxi) |> Repo.preload(:plan)
      update_attrs = %{"monthly_date" => "25/10/2018", "taxi_id" => taxi.id}

      assert {:ok, %Order{} = order} = Sales.update_order(order, update_attrs)
      assert order.value == taxi.plan.value
      assert order.monthly_date == ~D[2018-10-25]
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = insert(:order)
      taxi = insert(:taxi) |> Repo.preload(:plan)
      invalid_attrs = %{"monthly_date" => "", "taxi_id" => taxi.id}

      assert {:error, %Ecto.Changeset{}} = Sales.update_order(order, invalid_attrs)
      assert order.id == Sales.get_order!(order.id).id
    end

    test "delete_order/1 deletes the order" do
      order = insert(:order)
      assert {:ok, %Order{}} = Sales.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = insert(:order)
      assert %Ecto.Changeset{} = Sales.change_order(order)
    end
  end
end
