defmodule BerlimWeb.EmployeeViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.EmployeeView

  setup do
    %{
      employee: %{
        id: 1,
        name: "Danilo",
        internal_id: "123456",
        active: true
      }
    }
  end

  describe "index.json/2" do
    test "return employees", %{employee: employee} do
      assert EmployeeView.render("index.json", %{employees: [employee]}) == %{data: [employee]}
    end
  end

  describe "show.json/2" do
    test "returns employee", %{employee: employee} do
      assert EmployeeView.render("show.json", %{employee: employee}) == %{data: employee}
    end
  end

  describe "employee.json/2" do
    test "returns employee", %{employee: employee} do
      assert EmployeeView.render("employee.json", %{employee: employee}) == employee
    end
  end
end
