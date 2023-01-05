defmodule FilesChestCloudApiWeb.Auth.AuthErrorHandler do
  @moduledoc """
  Provides the function to handle pipeline authentication errors.
  """

  @behaviour Guardian.Plug.ErrorHandler

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    send_resp(conn, 401, body)
  end
end
