defmodule FilesChestCloudApiWeb.FilesCloudController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApi.Cloud.Files
  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApiWeb.Auth.Guardian

  def upload(conn, %{"upload" => upload_params}) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    response = Files.upload_file(upload_params, user_id)

    conn
    |> put_status(:ok)
    |> json(%{message: response})
  end
end
