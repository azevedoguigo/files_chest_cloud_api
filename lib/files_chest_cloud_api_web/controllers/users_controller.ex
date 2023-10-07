defmodule FilesChestCloudApiWeb.UsersController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApiWeb.Auth.Guardian
  alias FilesChestCloudApi.Accounts.{Create, Get, Update, Delete}
  alias FilesChestCloudApiWeb.Auth.UserAuth

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
    |> render("show.json", user: user)
  end

  def get_by_id(conn, %{"id" => id}) do
    with {:ok, user} <- Get.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  def update(conn, params_to_update) do
    with {:ok, updated_user} <- Update.update_user(params_to_update) do
      conn
      |> put_status(:ok)
      |> render("update.json", user: updated_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _user} <- Delete.delete_user(id) do
      conn
      |> put_status(:ok)
      |> json(%{message: "User deleted!"})
    end
  end
end
