# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :berlim,
  ecto_repos: [Berlim.Repo]

# Configures the endpoint
config :berlim, BerlimWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M+jc6lWzYh7UkEgqXhlEusHDzaLhNmLNrerZZQ7Q9Ch+or/7nUkMNmM+UDrwq7ik",
  render_errors: [view: BerlimWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Berlim.PubSub, adapter: Phoenix.PubSub.PG2]

config :berlim, BerlimWeb.Gettext, default_locale: "pt_BR"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
