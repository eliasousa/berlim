use Mix.Config

config :berlim, BerlimWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [scheme: "https", host: System.get_env("HOST_URL"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

config :berlim, Berlim.Guardian, secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Configure your database
config :berlim, Berlim.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
