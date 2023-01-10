defmodule FilesChestCloudApiWeb.UsersController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApi.Accounts.{Create, Get}
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

      {:error, error_message} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: error_message})
    end
  end

  def get_by_id(conn, %{"id" => id}) do
    case Get.get_user_by_id(id) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> json(%{user: user})

      {:error, message} ->
        case message do
          "Invalid id format!" ->
            conn
            |> put_status(:bad_request)
            |> json(%{message: message})

          "User does not exists!" ->
            conn
            |> put_status(:not_found)
            |> json(%{message: message})
        end
    end
  end
end
