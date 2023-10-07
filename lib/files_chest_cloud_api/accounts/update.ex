defmodule FilesChestCloudApi.Accounts.Update do
  @moduledoc """
  This module provides the update_user/1 function.
  """

  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo
  alias Ecto.UUID

  def update_user(%{"id" => id} = params_to_update) do
    case validate_id(id) do
      {:ok, valid_uuid} -> handle_get_user(valid_uuid, params_to_update)
      {:error, error_data} -> {:error, error_data}
    end
  end

  defp validate_id(id) do
    case UUID.cast(id) do
      {:ok, uuid} -> {:ok, uuid}
      :error -> {:error, %{message: "Invalid id format!", status_code: :bad_request}}
    end
  end

  defp handle_get_user(valid_uuid, params_to_update) do
    case Repo.get(User, valid_uuid) do
      nil -> {:error, %{message: "User does not exists!", status_code: :not_found}}
      user -> validate_password_and_update_user(user, params_to_update)
    end
  end

  defp validate_password_and_update_user(user, %{"currentPassword" => current_password} = params_to_update) do
    %User{password_hash: hash} = user

    case Argon2.verify_pass(current_password, hash) do
      false ->
        {:error, %{message: "Incorrect password!", status_code: :bad_request}}

      true ->
        # currentPassword is removed as it is only used to validate the password.
        params_to_update = Map.delete(params_to_update, "currentPassword")

        user
        |> User.changeset(params_to_update)
        |> Repo.update()
    end
  end
end
