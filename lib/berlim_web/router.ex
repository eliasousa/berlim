defmodule BerlimWeb.Router do
  use BerlimWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :ensure_admin do
    plug(BerlimWeb.Plugs.RequireAdminAuth)
  end

  pipeline :ensure_user_signed_in do
    plug(BerlimWeb.Plugs.RequireAuth)
    plug(BerlimWeb.Plugs.SetUser)
  end

  pipeline :redirect_logged_user do
    plug(BerlimWeb.Plugs.RedirectLoggedUser)
  end

  scope "/", BerlimWeb do
    pipe_through([:browser, :redirect_logged_user])

    get("/", HomeController, :index)
    resources("/sign-in", LoginController, only: [:new, :create])
  end

  scope "/sign-out", BerlimWeb do
    pipe_through([:browser, :ensure_user_signed_in])

    delete("/", LoginController, :delete)
  end

  scope "/", BerlimWeb do
    pipe_through([:browser, :ensure_user_signed_in, :ensure_admin])

    resources("/taxis", TaxiController, except: [:show, :delete])
  end

  scope "/dashboard", BerlimWeb do
    pipe_through([:browser, :ensure_user_signed_in])

    resources("/", DashboardController, only: [:index])
  end

  scope "/api", BerlimWeb do
    pipe_through(:api)

    resources("/admins", AdminController, except: [:new, :edit])
  end
end
