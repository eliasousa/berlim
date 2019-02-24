defmodule BerlimWeb.Router do
  use BerlimWeb, :router

  alias BerlimWeb.Plugs

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Plugs.AuthPipeline
  end

  pipeline :ensure_admin do
    plug Plugs.RequireAdminAuth
  end

  scope "/api", BerlimWeb do
    pipe_through :api

    resources("/users", UserController, only: [:create])
  end

  scope "/api", BerlimWeb do
    pipe_through [:api, :jwt_authenticated, :ensure_admin]

    resources("/admins", AdminController, except: [:new, :edit])
    resources("/taxis", TaxiController, except: [:new, :edit, :delete])
  end
end
