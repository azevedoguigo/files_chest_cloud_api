defmodule FilesChestCloudApi.Cloud.Files do
  @moduledoc """
  Provides functions to manage files in the cloud.
  """

  alias ExAws.S3

  @bucket_name "#{System.get_env("BUCKET_NAME")}"

  def get_file_info(user_id, filename) do
    {:ok, files_list} = list_files(user_id)

    file = Enum.find(files_list, fn file ->
      String.contains?(file.key, filename)
    end)

    file
  end

  def list_files(user_id) do
    files_list =
      S3.list_objects_v2(@bucket_name)
      |> ExAws.stream!()
      |> Enum.to_list()
      |> Enum.filter(fn file -> String.contains?(file.key, user_id) end)
      |> Enum.map(fn file ->
        Map.put(file, :key, String.slice(file.key, 37, String.length(file.key)))
      end)

    {:ok, files_list}
  end

  def download_file(user_id, filename) do
    file_path = "#{user_id}/#{filename}"

    config = ExAws.Config.new(:s3)

    {:ok, url} = S3.presigned_url(config, :get, @bucket_name, file_path)

    {:ok, url}
  end

  def upload_file(upload_params, user_id) do
    file = upload_params.path

    file_name = "#{DateTime.utc_now()}-#{upload_params.filename}"

    s3_path = "#{user_id}/#{file_name}"

    stream = S3.Upload.stream_file(file)
    request = S3.upload(stream, @bucket_name, s3_path)
    response = ExAws.request!(request)

    {:ok, response}
  end

  def delete_file(user_id, filename) do
    s3_path = "#{user_id}/#{filename}"

    file_info = get_file_info(user_id, filename)

    case file_info do
      nil -> {:error, "File does not exists!"}

      _file ->
        request = S3.delete_object(@bucket_name, s3_path)
        response = ExAws.request!(request)

        {:ok, response}
    end
  end
end
