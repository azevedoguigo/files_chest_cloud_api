defmodule FilesChestCloudApi.Accounts.GetTest do
  use FilesChestCloudApi.DataCase

  alias FilesChestCloudApi.Accounts.{User, Create, Get}

  describe "get_user_by_id/1" do
    test "When the id is valid and there is a user with that id, returns the user." do
      params = %{
        name: "Guigo",
        email: "guigo.test@example.com",
        password: "supersenha"
      }

      # Get the id of the new user.
      {:ok, %User{id: user_id}} = Create.register_user(params)

      assert {:ok, %User{id: ^user_id}} = Get.get_user_by_id(user_id)
    end

    test "When the entered id does not match any user, it returns an error message." do
      response = Get.get_user_by_id("64b66e39-ae33-4d4b-a1ff-08c4c2b5b999")

      expected_response = {
        :error,
        %{message: "User does not exists!", status_code: :not_found}
      }

      assert expected_response == response
    end

    test "When the id format is invalid, it returns an error message." do
      response = Get.get_user_by_id("invalid_id_format")

      expected_response = {
        :error,
        %{message: "Invalid id format!", status_code: :bad_request}
      }

      assert expected_response == response
    end
  end
end
