defmodule Berlim.Sales.PlanTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.Sales.Plan

  @valid_attrs params_for(:plan)

  test "changeset with valid attributes" do
    changeset = Plan.changeset(%Plan{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Plan.changeset(%Plan{}, %{})
    refute changeset.valid?
  end
end
