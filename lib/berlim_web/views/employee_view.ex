defmodule BerlimWeb.EmployeeView do
  use BerlimWeb, :view
  alias BerlimWeb.EmployeeView

  def render("index.json", %{employees: employees}) do
    %{data: render_many(employees, EmployeeView, "employee.json")}
  end

  def render("show.json", %{employee: employee}) do
    %{data: render_one(employee, EmployeeView, "employee.json")}
  end

  def render("employee.json", %{employee: employee}) do
    %{
      id: employee.id,
      name: employee.name,
      email: employee.email,
      internal_id: employee.internal_id,
      active: employee.active,
      sector_id: employee.sector_id,
      sector: sector_json(employee.sector)
    }
  end

  defp sector_json(%{} = sector), do: %{name: sector.name}
  defp sector_json(_), do: nil
end
