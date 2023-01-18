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

  def download(conn, %{"filename" => filename}) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    {:ok, url} = Files.download_file(user_id, filename)

    conn
    |> put_status(:ok)
    |> json(%{download_url: url})
  end

  def upload(conn, %{"upload" => upload_params}) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    response = Files.upload_file(upload_params, user_id)

    conn
    |> put_status(:ok)
    |> json(%{message: response})
  end

  def delete(conn, %{"filename" => filename}) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    {:ok, %{status_code: status_code}} = Files.delete_file(user_id, filename)

    case status_code do
      204 ->
        conn
        |> put_status(:ok)
        |> json(%{message: "File successfully deleted!"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Something went wrong while deleting the file..."})
    end
  end
end
