defmodule FilesChestCloudApiWeb.UsersView do
  use FilesChestCloudApiWeb, :view

  def render("create.json", %{user: user}) do
    %{message: "User registred!", user: user}
  end

  def render("sign_in.json", %{token: token}), do: %{token: token}
end
