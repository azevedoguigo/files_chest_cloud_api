defmodule FilesChestCloudApi.Cloud.Files do
  @moduledoc """
  Provides functions to manage files in the cloud.
  """

  alias ExAws.S3

  def list_files(user_id) do
    bucket_name = System.get_env("BUCKET_NAME")

    # Get the files and returns only the file names.
    files_list =
      S3.list_objects_v2(bucket_name)
      |> ExAws.stream!()
      |> Enum.to_list()
      |> Enum.map(fn file -> Map.fetch(file, :key) end)
      |> Enum.filter(fn {:ok, file_path} -> String.contains?(file_path, user_id) end)
      |> Enum.map(fn {:ok, file_path} -> String.slice(file_path, 37, String.length(file_path)) end)

    files_list
  end

  def upload_file(upload_params, user_id) do
    file = upload_params.path
    file_name = upload_params.filename

    bucket_name = System.get_env("BUCKET_NAME")

    s3_path = "#{user_id}/#{file_name}"

    file
    |> S3.Upload.stream_file()
    |> S3.upload(bucket_name, s3_path)
    |> ExAws.request!()

    s3_url = "http://#{bucket_name}.s3.amazonaws.com/#{s3_path}"

    %{s3_url: s3_url}
  end
end
