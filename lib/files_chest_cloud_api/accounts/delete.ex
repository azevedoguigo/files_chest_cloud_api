defmodule FilesChestCloudApi.Accounts.Delete do
  @moduledoc """
  This module provides the delete_user/1 function.
  """

  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo
  alias Ecto.UUID

  def delete_user(id) do
    case validate_id(id) do
      {:ok, valid_uuid} -> handle_get_user(valid_uuid)
      {:error, error_data} -> {:error, error_data}
    end
  end

  defp validate_id(id) do
    case UUID.cast(id) do
      {:ok, uuid} -> {:ok, uuid}
      :error -> {:error, %{message: "Invalid id format!", status_code: :bad_request}}
    end
  end

  defp handle_get_user(valid_uuid) do
    case Repo.get(User, valid_uuid) do
      nil -> {:error, %{message: "User does not exists!", status_code: :not_found}}
      user -> {:ok, user}
    end
  end
end
