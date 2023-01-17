defmodule FilesChestCloudApiWeb.FilesCloudController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApi.Cloud.Upload
  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApiWeb.Auth.Guardian

  def upload(conn, %{"upload" => upload_params}) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    response = Upload.upload_file(upload_params, user_id)

    conn
    |> put_status(:ok)
    |> json(%{message: response})
  end
end
