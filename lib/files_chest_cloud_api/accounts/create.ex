defmodule FilesChestCloudApi.Accounts.Create do
  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo

  def register_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
