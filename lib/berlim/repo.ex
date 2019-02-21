defmodule Berlim.Repo do
  use Ecto.Repo,
    otp_app: :berlim,
    adapter: Ecto.Adapters.Postgres
end
