defmodule BerlimWeb.Plugs.AuthPipeline do
  @moduledoc """
  Guardian auth pipelines.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :Berlim,
    module: Berlim.Guardian,
    error_handler: BerlimWeb.Plugs.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
