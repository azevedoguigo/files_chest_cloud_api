defmodule FilesChestCloudApiWeb.UsersView do
  use FilesChestCloudApiWeb, :view

  def render("sign_in.json", %{token: token}), do: %{token: token}
end
