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
end
