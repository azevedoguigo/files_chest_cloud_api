defmodule FilesChestCloudApiWeb.Auth.UserAuthTest do
  use FilesChestCloudApi.DataCase

  alias FilesChestCloudApi.Accounts.{User, Create}
  alias FilesChestCloudApiWeb.Auth.UserAuth

  @user_default_params %{
    name: "Guigo",
    email: "guigo.test@example.com",
    password: "supersenha"
  }

  describe "authenticate/1" do
    test "When email and password are valid, it authenticates the user." do
      {:ok, %User{email: email, password: password}} = Create.register_user(@user_default_params)

      assert {:ok, _token} = UserAuth.authenticate(%{"email" => email, "password" => password})
    end

    test "When the provided email is not registred, returns an error message." do
      response = UserAuth.authenticate(%{"email" => "wrong_email@example.com", "password" => "test"})

      expected_response = %{message: "Email not registred!", status_code: :not_found}

      assert expected_response == response
    end

    test "When the supplied password is not correct, it returns an error message." do
      {:ok, %User{email: email}} = Create.register_user(@user_default_params)

      response = UserAuth.authenticate(%{"email" => email, "password" => "wrong_password"})

      expected_response = %{message: "Invalid password!", status_code: :unauthorized}

      assert expected_response == response
    end
  end

  describe "validate_password/2" do
    test "If the entered password is correct, it returns a token." do
      {:ok, user} = Create.register_user(@user_default_params)

      assert {:ok, _user} = UserAuth.validate_password(user, "supersenha")
    end

    test "If the entered password is incorrect, it returns a error." do
      {:ok, user} = Create.register_user(@user_default_params)

      expected_response = %{message: "Invalid password!", status_code: :unauthorized}

      assert expected_response == UserAuth.validate_password(user, "wrong_password")
    end
  end
end
