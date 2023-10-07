defmodule FilesChestCloudApiWeb.UsersController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApiWeb.Auth.Guardian
  alias FilesChestCloudApi.Accounts.{Create, Get, Update, Delete}
  alias FilesChestCloudApiWeb.Auth.UserAuth
  alias FilesChestCloudApiWeb.ErrorHandler

  action_fallback FilesChestCloudApiWeb.FallbackController

  def create(conn, params) do
    with {:ok, user} <- Create.register_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  def sign_in(conn, credentials) do
    with {:ok, token} <- UserAuth.authenticate(credentials) do
      conn
      |> put_status(:ok)
      |> render("sign_in.json", token: token)
    end
  end

  def get_current_user(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> json(%{user: user})
  end

  def get_by_id(conn, %{"id" => id}) do
    with {:ok, user} <- Get.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("get_by_id.json", user: user)
    end
  end

  def update(conn, params_to_update) do
    with {:ok, updated_user} <- Update.update_user(params_to_update) do
      conn
      |> put_status(:ok)
      |> json(%{message: "User updated!", user: updated_user})

    else
      {:error, "Invalid id format!"} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Invalid id format!"})

      {:error, "User does not exists!"} ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User does not exists!"})

      {:error, "Incorrect password!"} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Incorrect password!"})

      {:error, invalid_changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: ErrorHandler.translate_errors(invalid_changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _user} <- Delete.delete_user(id) do
      conn
      |> put_status(:ok)
      |> json(%{message: "User deleted!"})

    else
      {:error, "Invalid id format!"} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Invalid id format!"})

      {:error, "User does not exists!"} ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "User does not exists!"})
    end
  end
end
