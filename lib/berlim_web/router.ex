defmodule BerlimWeb.Router do
  use BerlimWeb, :router

  alias BerlimWeb.Plugs

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :ensure_auth_and_assign do
    plug Plugs.Guardian.AuthPipeline
    plug Plugs.AssignUser
  end

  pipeline :ensure_admin do
    plug Plugs.RequireAdminAuth
  end

  pipeline :ensure_company do
    plug Plugs.RequireCompanyAuth
  end

  pipeline :ensure_taxi do
    plug Plugs.RequireTaxiAuth
  end

  scope "/api", BerlimWeb do
    pipe_through :api

    resources("/sessions", SessionController, only: [:create])
  end

  scope "/api", BerlimWeb do
    pipe_through [:api, :ensure_auth_and_assign, :ensure_admin]

    resources("/admins", AdminController, only: [:index, :show, :create, :update, :delete])
    resources("/taxis", TaxiController, only: [:index, :show, :create, :update])
    resources("/companies", CompanyController, only: [:index, :show, :create, :update])
  end

  scope "/api", BerlimWeb do
    pipe_through([:api, :ensure_auth_and_assign, :ensure_company])

    resources("/sectors", SectorController, only: [:index, :show, :create, :update])
    resources("/employees", EmployeeController, only: [:index, :show, :create, :update])
  end

  scope "/api", BerlimWeb do
    pipe_through([:api, :ensure_auth_and_assign])

    resources("/vouchers", VoucherController, only: [:index, :show])
  end

  scope "/api", BerlimWeb do
    pipe_through([:api, :ensure_auth_and_assign, :ensure_taxi])

    resources("/vouchers", VoucherController, only: [:create])
  end
end
