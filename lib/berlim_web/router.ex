defmodule BerlimWeb.Router do
  use BerlimWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BerlimWeb do
    pipe_through :api

    resources("/admins", AdminController, except: [:new, :edit])
    resources("/taxis", TaxiController, except: [:new, :edit, :delete])
  end
end
