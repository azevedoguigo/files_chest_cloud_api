defmodule FilesChestCloudApi.Accounts.Update do
  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo
  alias Ecto.UUID

  def update_user(%{"id" => user_id} = params_to_update) do
    case UUID.cast(user_id) do
      :error -> {:error, "Invalid id format!"}

      {:ok, _uuid} ->
        case Repo.get(User, user_id) do
          nil -> {:error, "User does not exists!"}

          user ->
            user
            |> User.changeset(params_to_update)
            |> Repo.update()
        end
    end
  end
end
