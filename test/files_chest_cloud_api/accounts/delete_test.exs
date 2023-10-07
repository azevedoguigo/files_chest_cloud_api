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
      response = Delete.delete_user("36cfbe97-d9dd-46b2-8287-6e8e8cc626ef")

      expected_response = {
        :error,
        %{message: "User does not exists!", status_code: :not_found}
      }
      assert expected_response == response
    end

    test "When an invalid id is provided, it returns an error message." do
      response = Delete.delete_user("invalid_id")

      expected_response = {
        :error,
        %{message: "Invalid id format!", status_code: :bad_request}
      }

      assert expected_response == response
    end
  end
end
