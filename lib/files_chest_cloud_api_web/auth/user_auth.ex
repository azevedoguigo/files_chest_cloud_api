defmodule FilesChestCloudApiWeb.Auth.UserAuth do
  @moduledoc """
  Provides useful functions for user authentication.
  """

  alias FilesChestCloudApiWeb.Auth.Guardian
  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo

  def authenticate(%{"id" => id, "password" => password}) do
    case Repo.get(User, id) do
      nil -> {:error, "User does not exists!"}
      user -> validate_password(user, password)
    end
  end

  def validate_password(%User{password_hash: hash} = user, password) do
    case Argon2.verify_pass(password, hash) do
      true -> create_token(user)
      false -> {:error, :unauthorized}
    end
  end

  defp create_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    {:ok, token}
  end
end
