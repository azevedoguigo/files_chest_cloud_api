defmodule FilesChestCloudApi.Repo do
  use Ecto.Repo,
    otp_app: :files_chest_cloud_api,
    adapter: Ecto.Adapters.Postgres
end
