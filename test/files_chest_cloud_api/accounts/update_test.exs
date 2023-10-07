defmodule FilesChestCloudApi.Accounts.UpdateTest do
  use FilesChestCloudApi.DataCase

  alias FilesChestCloudApi.Accounts.{User, Create, Update}

  @user_default_params %{
    name: "Guigo",
    email: "guigo.test@example.com",
    password: "supersenha"
  }

  describe "update_user/1" do
    test "When the parameters are valid and the password is provided, update the user." do
      {:ok, %User{id: user_id}} = Create.register_user(@user_default_params)

      params_to_update = %{
        "id" => user_id,
        "email" => "updated_email@example.com",
        "password" => "new_password",
        "currentPassword" => "supersenha"
      }

      response = Update.update_user(params_to_update)

      assert {:ok, %User{email: "updated_email@example.com"}} = response
    end

    test "When the parameters are valid but the user's password is not supplied, it returns an error message." do
      {:ok, %User{id: user_id}} = Create.register_user(@user_default_params)

      params_to_update = %{
        "id" => user_id,
        "email" => "updated_email@example.com",
        "password" => "",
        "currentPassword" => "supersenha"
      }

      {:error, invalid_changeset} = Update.update_user(params_to_update)

      assert errors_on(invalid_changeset) == %{password: ["can't be blank"]}
    end

    test "When any parameter is invalid, it returns an error message." do
      {:ok, %User{id: user_id}} = Create.register_user(@user_default_params)

      params_to_update = %{
        "id" => user_id,
        "email" => "",
        "password" => "supersenha",
        "currentPassword" => "supersenha"
      }

      {:error, invalid_changeset} = Update.update_user(params_to_update)

      assert errors_on(invalid_changeset) == %{email: ["can't be blank"]}
    end

    test "When the provided is not assigned to any user, it returns an error message." do
      params_to_update = %{
        "id" => "4e27ecb5-cb0b-4674-99cd-522656aec893",
        "email" => "updated_email@example.com",
        "password" => "supersenha",
        "currentPassword" => "supersenha"
      }

      response = Update.update_user(params_to_update)

      exected_response = {
        :error,
        %{message: "User does not exists!", status_code: :not_found}
      }

      assert exected_response == response
    end

    test "When the provided id is invalid, it returns an error message." do
      params_to_update = %{
        "id" => "invalid_id_format",
        "email" => "updated_email@example.com",
        "password" => "supersenha",
        "currentPassword" => "supersenha"
      }

      response = Update.update_user(params_to_update)

      expected_response = {
        :error,
        %{message: "Invalid id format!", status_code: :bad_request}
      }

      assert expected_response == response
    end
  end
end
