defmodule FilesChestCloudApiWeb.UsersController do
  use FilesChestCloudApiWeb, :controller

  alias FilesChestCloudApi.Accounts.Create

  def create(conn, params) do
    case Create.register_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "User registred!", user: user})

      {:error, _changeset}->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Error to register the user!"})
    end
  end
end
