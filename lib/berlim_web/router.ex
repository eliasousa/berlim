defmodule BerlimWeb.Router do
  use BerlimWeb, :router

  alias BerlimWeb.Plugs

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :ensure_auth do
    plug Plugs.Guardian.AuthPipeline
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

  pipeline :ensure_old_token do
    plug Plugs.RequireOldToken
  end

  scope "/api", BerlimWeb do
    pipe_through :api

    resources("/sessions", SessionController, only: [:create])
  end

  scope "/api", BerlimWeb do
    pipe_through [:api, :ensure_auth, :ensure_admin]

    resources("/admins", AdminController, only: [:index, :show, :create, :update, :delete])
    resources("/taxis", TaxiController, only: [:index, :show, :create, :update])
    resources("/companies", CompanyController, only: [:index, :show, :create, :update])
  end

  scope "/api", BerlimWeb do
    pipe_through([:api, :ensure_auth, :ensure_company])

    resources("/sectors", SectorController, only: [:index, :show, :create, :update])
    resources("/employees", EmployeeController, only: [:index, :show, :create, :update])
  end

  scope "/api", BerlimWeb do
    pipe_through([:api, :ensure_auth])

    resources("/vouchers", VoucherController, only: [:index, :show])
  end

  scope "/api", BerlimWeb do
    pipe_through([:api, :ensure_auth, :ensure_taxi])

    resources("/vouchers", VoucherController, only: [:create])
  end

  scope "/api", BerlimWeb do
    pipe_through([:api, :ensure_old_token])

    get "/taxistas", Old.TaxiController, :show, as: :old_taxi
    get "/funcionarios", Old.EmployeeController, :show, as: :old_employee
    get "/vouchers/taxista/:id", Old.VoucherController, :index, as: :old_voucher
  end
end
