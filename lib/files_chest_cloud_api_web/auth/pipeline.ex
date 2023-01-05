defmodule FilesChestCloudApiWeb.Auth.Pipeline do
  @moduledoc """
  Provides pipeline with Guardian plugs.
  """

  use Guardian.Plug.Pipeline, otp_app: :files_chest_cloud_api

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
