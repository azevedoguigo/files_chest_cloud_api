defmodule FilesChestCloudApi.Accounts.Create do
  @moduledoc """
  This module provides the register_user/1 function.
  """

  alias FilesChestCloudApi.Accounts.User
  alias FilesChestCloudApi.Repo

  def register_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
