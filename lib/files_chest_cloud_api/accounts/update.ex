defmodule FilesChestCloudApi.Accounts.Update do
  @moduledoc """
  This module provides the update_user/1 function.
  """

  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo
  alias Ecto.UUID

  def update_user(%{"id" => id} = params_to_update) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid id format!"}

      {:ok, _uuid} ->
        case Repo.get(User, id) do
          nil ->
            {:error, "User does not exists!"}

          user ->
            validate_password_and_update_user(user, params_to_update)
        end
    end
  end

  defp validate_password_and_update_user(user, %{"currentPassword" => current_password} = params_to_update) do
    %User{password_hash: hash} = user

    case Argon2.verify_pass(current_password, hash) do
      false ->
        {:error, "Incorrect password!"}

      true ->
        params_to_update = Map.delete(params_to_update, "currentPassword")

        user
        |> User.changeset(params_to_update)
        |> Repo.update()
    end
  end
end
