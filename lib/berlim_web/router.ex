defmodule BerlimWeb.Router do
  use BerlimWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(BerlimWeb.Plugs.SetUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :ensure_admin do
    plug(BerlimWeb.Plugs.RequireAdminAuth)
  end

  pipeline :ensure_user_signed_in do
    plug(BerlimWeb.Plugs.RequireAuth)
  end

  pipeline :redirect_logged_user do
    plug(BerlimWeb.Plugs.RedirectLoggedUser)
  end

  scope "/", BerlimWeb do
    pipe_through([:browser, :redirect_logged_user])

    get("/", HomeController, :index)
    get("/sign-in", LoginController, :new)
    post("/sign-in", LoginController, :create)
  end

  scope "/sign-out", BerlimWeb do
    pipe_through(:browser)

    delete("/", LoginController, :delete)
  end

  scope "/", BerlimWeb do
    pipe_through([:browser, :ensure_user_signed_in, :ensure_admin])

    resources("/admins", AdminController, except: [:show])
    resources("/taxis", TaxiController, except: [:show, :delete])
    resources("/plans", PlanController, except: [:show, :delete])
  end

  scope "/dashboard", BerlimWeb do
    pipe_through([:browser, :ensure_user_signed_in])

    resources("/", DashboardController, only: [:index])
  end

  # Other scopes may use custom stacks.
  # scope "/api", BerlimWeb do
  #   pipe_through :api
  # end
end
