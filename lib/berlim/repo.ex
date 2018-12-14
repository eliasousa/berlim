defmodule Berlim.Repo do
  use Ecto.Repo,
    otp_app: :berlim,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 30
end
