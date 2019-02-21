defmodule BerlimWeb.TaxiView do
  use BerlimWeb, :view
  alias BerlimWeb.TaxiView

  def render("index.json", %{taxis: taxis}) do
    %{data: render_many(taxis, TaxiView, "taxi.json")}
  end

  def render("show.json", %{taxi: taxi}) do
    %{data: render_one(taxi, TaxiView, "taxi.json")}
  end

  def render("taxi.json", %{taxi: taxi}) do
    %{
      id: taxi.id,
      cpf: taxi.cpf,
      smtt: taxi.smtt,
      email: taxi.email,
      phone: taxi.phone,
      active: taxi.active
    }
  end
end
