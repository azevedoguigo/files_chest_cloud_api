defmodule FilesChestCloudApiWeb.FallbackController do
  use FilesChestCloudApiWeb, :controller

  def call(conn, %{status_code: :unauthorized} = error_data) do
    conn
      |> put_status(error_data.status_code)
      |> put_view(FilesChestCloudApiWeb.ErrorView)
      |> render("401.json", message: error_data.message)
  end

  def call(conn, %{status_code: :not_found} = error_data) do
    conn
      |> put_status(error_data.status_code)
      |> put_view(FilesChestCloudApiWeb.ErrorView)
      |> render("404.json", message: error_data.message)
  end
end
