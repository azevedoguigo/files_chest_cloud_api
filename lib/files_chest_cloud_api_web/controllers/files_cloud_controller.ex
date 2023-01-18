defmodule FilesChestCloudApiWeb.FilesCloudController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApi.Cloud.Files
  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApiWeb.Auth.Guardian

  def list_files(conn, _) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    files_list = Files.list_files(user_id)

    conn
    |> put_status(:ok)
    |> json(%{files: files_list})
  end

  def upload(conn, %{"upload" => upload_params}) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    response = Files.upload_file(upload_params, user_id)

    conn
    |> put_status(:ok)
    |> json(%{message: response})
  end
end
