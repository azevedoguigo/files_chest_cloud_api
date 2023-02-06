defmodule FilesChestCloudApi.Accounts.Delete do
  @moduledoc """
  This module provides the delete_user/1 function.
  """

  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo
  alias Ecto.UUID

  def delete_user(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid id format!"}
      {:ok, _uuid} ->
        case Repo.get(User, id) do
          nil -> {:error, "User does not exists!"}
          user -> Repo.delete(user)
        end
    end
  end
end
