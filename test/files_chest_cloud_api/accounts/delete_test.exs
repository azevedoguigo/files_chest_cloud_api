defmodule FilesChestCloudApi.Accounts.DeleteTest do
  use FilesChestCloudApi.DataCase

  alias FilesChestCloudApi.Accounts.{User, Create, Delete}

  describe "delete_user/1" do
    test "When the id is valid and there is a user with that id, delete the user." do
      user = %{
        name: "Guigo",
        email: "guigo.test@example.com",
        password: "supersenha"
      }

      {:ok, %User{id: user_id}} = Create.register_user(user)

      assert {
        :ok,
        %User{
          id: ^user_id,
          name: "Guigo",
          email: "guigo.test@example.com"
        }
      } = Delete.delete_user(user_id)
    end

    test "When an id is provided that is not assigned to any user, it returns an error message." do
      assert {:error, "User does not exists!"} == Delete.delete_user("36cfbe97-d9dd-46b2-8287-6e8e8cc626ef")
    end

    test "When an invalid id is provided, it returns an error message." do
      assert {:error, "Invalid id format!"} == Delete.delete_user("invalid_id")
    end
  end
end
