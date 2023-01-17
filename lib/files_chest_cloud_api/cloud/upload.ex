defmodule FilesChestCloudApi.Cloud.Upload do
  @moduledoc """
  File upload service to AWS S3.
  """

  alias ExAws.S3

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
