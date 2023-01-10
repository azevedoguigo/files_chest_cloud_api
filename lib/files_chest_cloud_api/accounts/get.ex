defmodule FilesChestCloudApi.Accounts.Get do
  alias FilesChestCloudApi.Repo
  alias FilesChestCloudApi.Accounts.User
  alias Ecto.UUID

  def get_user_by_id(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid id format!"}
      {:ok, _uuid} ->
        case {:ok, Repo.get(User, id)} do
          {:ok, nil} -> {:error, "User does not exists!"}
          {:ok, user} -> {:ok, user}
        end
    end
  end
end
