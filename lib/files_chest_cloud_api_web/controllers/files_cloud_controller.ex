defmodule FilesChestCloudApiWeb.FilesCloudController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApi.Cloud.Files
  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApiWeb.Auth.Guardian

  def get_file_info(conn, %{"filename" => filename}) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    file = Files.get_file_info(user_id, filename)

    case file do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "File does not exists!"})

      file ->
        conn
        |> put_status(:ok)
        |> json(%{file: file})
    end
  end

  def list_files(conn, _) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    {:ok, files_list} = Files.list_files(user_id)

    conn
    |> put_status(:ok)
    |> json(files_list)
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

    {:ok, %{status_code: status_code}} = Files.upload_file(upload_params, user_id)

    case status_code do
      200 ->
        conn
        |> put_status(status_code)
        |> json(%{message: "File successfully uploaded!"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Something went wrong while uploading the file..."})
    end
  end

  def delete(conn, %{"filename" => filename}) do
    %User{id: user_id} = Guardian.Plug.current_resource(conn)

    response = Files.delete_file(user_id, filename)

    case response do
      {:ok, %{status_code: status_code}} ->
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

      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> json(%{message: message})
    end
  end
end
