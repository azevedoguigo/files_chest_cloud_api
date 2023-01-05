defmodule FilesChestCloudApiWeb.UsersController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApi.Accounts.Create
  alias FilesChestCloudApiWeb.Auth.UserAuth
  alias FilesChestCloudApiWeb.ErrorHandler

  def create(conn, params) do
    case Create.register_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "User registred!", user: user})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: ErrorHandler.translate_errors(changeset)})
    end
  end

  def sign_in(conn, credentials) do
    case UserAuth.authenticate(credentials) do
      {:ok, token} ->
        conn
        |> put_status(:ok)
        |> json(%{token: token})

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Email or password invalid!"})
    end
  end
end
