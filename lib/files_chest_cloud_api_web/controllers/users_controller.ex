defmodule FilesChestCloudApiWeb.UsersController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApi.Accounts.{Create, Get, Update, Delete}
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

  def update(conn, params_to_update) do
    case Update.update_user(params_to_update) do
      {:ok, updated_user} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "User updated!", user: updated_user})

      {:error, reason} ->
        case reason do
          "Invalid id format!" ->
            conn
            |> put_status(:bad_request)
            |> json(%{message: reason})

          "User does not exists!" ->
            conn
            |> put_status(:not_found)
            |> json(%{message: reason})

          invalid_changeset ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: ErrorHandler.translate_errors(invalid_changeset)})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Delete.delete_user(id) do
      {:ok, _user} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "User deleted!"})

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
