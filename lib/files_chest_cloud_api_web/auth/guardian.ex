defmodule FilesChestCloudApiWeb.Auth.Guardian do
  @moduledoc """
  Implementation module that provides functions for the Guardian to encode and decode token values.
  """

  use Guardian, otp_app: :files_chest_cloud_api

  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = Repo.get(User, id)
    {:ok, resource}
  end
end
