defmodule BerlimWeb.Router do
  use BerlimWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :ensure_admin do
    plug BerlimWeb.Plugs.RequireAdminAuth
  end

  scope "/", BerlimWeb do
    pipe_through :browser

    get "/", LoginController, :index

    resources "/admins", AdminController, except: [:show]
  end

  scope "/taxis", BerlimWeb do
    pipe_through [:browser, :ensure_admin]

    resources "/", TaxiController, except: [:show, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", BerlimWeb do
  #   pipe_through :api
  # end
end
