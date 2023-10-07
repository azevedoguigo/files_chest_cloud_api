defmodule FilesChestCloudApiWeb.UsersView do
  use FilesChestCloudApiWeb, :view

  def render("create.json", %{user: user}) do
    %{message: "User registred!", user: user}
  end

  def render("show.json", %{user: user}), do: %{user: user}

  def render("update.json", %{user: user}) do
    %{message: "User updated!", user: user}
  end

  def render("delete.json", message), do: message

  def render("sign_in.json", %{token: token}), do: %{token: token}
end
