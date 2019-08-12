defmodule BerlimWeb.Plugs.Guardian.AuthPipeline do
  @moduledoc """
  Guardian auth pipelines.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :Berlim,
    module: BerlimWeb.Guardian,
    error_handler: BerlimWeb.Plugs.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
