defmodule FilesChestCloudApiWeb.Auth.UserAuth do
  @moduledoc """
  Provides useful functions for user authentication.
  """

  alias FilesChestCloudApiWeb.Auth.Guardian
  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo

  def authenticate(%{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "Email not registred!"}
      user -> validate_password(user, password)
    end
  end

  def validate_password(%User{password_hash: hash} = user, password) do
    case Argon2.verify_pass(password, hash) do
      true -> create_token(user)
      false -> {:error, "Invalid password!"}
    end
  end

  defp create_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    {:ok, token}
  end
end
