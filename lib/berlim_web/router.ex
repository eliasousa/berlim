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

  pipeline :check_sector_owner do
    plug Plugs.CheckCompanyOwns, :sector
  end

  pipeline :check_employee_owner do
    plug Plugs.CheckCompanyOwns, :employee
  end

  scope "/api", BerlimWeb do
    pipe_through :api

    resources("/sessions", SessionController, only: [:create])
  end

  scope "/api", BerlimWeb do
    pipe_through [:api, :ensure_auth, :ensure_admin]

    resources("/admins", AdminController, except: [:new, :edit])
    resources("/taxis", TaxiController, except: [:new, :edit, :delete])
    resources("/companies", CompanyController, except: [:new, :edit, :delete])
  end

  scope "/api", BerlimWeb do
    pipe_through([:api, :ensure_auth, :ensure_company])

    resources("/sectors", SectorController, only: [:index, :create])
    resources("/employees", EmployeeController, only: [:index, :create])
  end

  scope "/api", BerlimWeb do
    pipe_through [:api, :ensure_auth, :ensure_company, :check_sector_owner]

    resources("/sectors", SectorController, only: [:show, :update])
  end

  scope "/api", BerlimWeb do
    pipe_through [:api, :ensure_auth, :ensure_company, :check_employee_owner]

    resources("/employees", EmployeeController, only: [:show, :update])
  end
end
