defmodule FilesChestCloudApiWeb.UsersControllerTest do
  use FilesChestCloudApiWeb.ConnCase

  alias FilesChestCloudApiWeb.Auth.Guardian
  alias FilesChestCloudApi.Accounts.{User, Create}

  @user_default_params %{
    name: "Guigo",
    email: "guigo.test@example.com",
    password: "supersenha"
  }

  setup %{conn: conn} do
    # Create user to authenticate.
    user_params = %{
      name: "Guigo",
      email: "guigo.test.auth@example.com",
      password: "supersenha"
    }

    {:ok, user} = Create.register_user(user_params)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    {:ok, conn: conn}
  end

  describe "create/2" do
    test "When all parameters are valid, it registers the user.", %{conn: conn} do
      response =
        conn
        |> post(Routes.users_path(conn, :create, @user_default_params))
        |> json_response(:created)

      assert %{"message" => "User registred!"} = response
    end

    test "When any of the parameters for user creation is invalid, it returns an error message.", %{conn: conn} do
      # The email provided is not in a valid format.
      params = %{
        name: "Guigo",
        email: "guigo.testexample.com",
        password: "supersenha"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{"error" => %{"email" => ["has invalid format"]}} == response
    end
  end

  describe "sign_in/2" do
    test "When credentials are valid, it returns a token.", %{conn: conn} do
      Create.register_user(@user_default_params)

      credentials = %{email: "guigo.test@example.com", password: "supersenha"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, credentials))
        |> json_response(:ok)

      token = response
      assert token == response
    end

    test "When the email is invalid, it returns an error message.", %{conn: conn} do
      Create.register_user(@user_default_params)

      credentials = %{email: "wrong_email@example.com", password: "supersenha"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, credentials))
        |> json_response(:unauthorized)

      assert %{"message" => "Email not registred!"} == response
    end

    test "When the password is invalid, it returns an error message.", %{conn: conn} do
      Create.register_user(@user_default_params)

      credentials = %{email: "guigo.test@example.com", password: "wrong_password"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, credentials))
        |> json_response(:unauthorized)

      assert %{"message" => "Invalid password!"} == response
    end
  end

  describe "get_current_user/1" do
    test "When the token is valid, it returns the current user.", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :get_current_user))
        |> json_response(:ok)

      assert %{
        "user" => %{
          "email" => "guigo.test.auth@example.com",
          "name" => "Guigo"
        }
      } = response
    end
  end

  describe "get_by_id/2" do
    test "Returns user information when the id is valid and registered.", %{conn: conn} do
      # Get the id of the new user.
      {:ok, %User{id: user_id}} = Create.register_user(@user_default_params)

      response =
        conn
        |> get(Routes.users_path(conn, :get_by_id, %{"id" => user_id}))
        |> json_response(:ok)

      assert %{"user" => %{"id" => ^user_id}} = response
    end

    test "When the id entered does not belong to any user, it returns an error message.", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :get_by_id, %{"id" => "50dc5f92-053a-411e-99a6-566b04c79b67"}))
        |> json_response(:not_found)

      assert %{"message" => "User does not exists!"} == response
    end

    test "When the provided id is not valid, it returns an error message.", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :get_by_id, %{"id" => "invalid_id_format"}))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid id format!"} == response
    end
  end

  describe "delete/2" do
    test "Delete user account when the id is valid and registered.", %{conn: conn} do
      # Get the id of new user.
      {:ok, %User{id: user_id}} = Create.register_user(@user_default_params)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, %{"id" => user_id}))
        |> json_response(:ok)

      assert %{"message" => "User deleted!"} == response
    end

    test "When the id entered does not belong to any user, it returns an error message.", %{conn: conn} do
      response =
        conn
        |> delete(Routes.users_path(conn, :delete, %{"id" => "2df2498f-6f64-46bf-82ad-6d4343dd9b59"}))
        |> json_response(:not_found)

      assert %{"message" => "User does not exists!"} == response
    end

    test "When the provided id is not valid, it returns an error message.", %{conn: conn} do
      response =
        conn
        |> delete(Routes.users_path(conn, :delete, %{"id" => "invalid_id_format"}))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid id format!"} == response
    end
  end

  describe "update/2" do
    test "Updates user data when parameters are valid.", %{conn: conn} do
      {:ok, %User{id: user_id}} = Create.register_user(@user_default_params)

      params_to_update = %{
        "id" => user_id,
        "email" => "updated_email@example.com",
        "password" => "supersenha",
        "currentPassword" => "supersenha"
      }

      response =
        conn
        |> put(Routes.users_path(conn, :update, params_to_update))
        |> json_response(:ok)

      assert %{
        "message" => "User updated!",
        "user" => %{
          "email" => "updated_email@example.com"
        }
      } = response
    end

    test "When the parameters are valid but the user's password is not supplied, it returns an error message.", %{conn: conn} do
      {:ok, %User{id: user_id}} = Create.register_user(@user_default_params)

      params_to_update = %{
        "id" => user_id,
        "email" => "updated_email@example.com",
        "password" => "",
        "currentPassword" => "supersenha"
      }

      response =
        conn
        |> put(Routes.users_path(conn, :update, params_to_update))
        |> json_response(:bad_request)

      assert %{"error" => %{"password" => ["can't be blank"]}} == response
    end

    test "When any parameter is invalid, it returns an error message.", %{conn: conn} do
      {:ok, %User{id: user_id}} = Create.register_user(@user_default_params)

      params_to_update = %{
        "id" => user_id,
        "email" => "",
        "password" => "supersenha",
        "currentPassword" => "supersenha"
      }

      response =
        conn
        |> put(Routes.users_path(conn, :update, params_to_update))
        |> json_response(:bad_request)

      assert %{"error" => %{"email" => ["can't be blank"]}} == response
    end

    test "When the provided is not assigned to any user, it returns an error message.", %{conn: conn} do
      params_to_update = %{
        "id" => "4e27ecb5-cb0b-4674-99cd-522656aec893",
        "email" => "updated_email@example.com",
        "password" => "supersenha",
        "currentPassword" => "supersenha"
      }

      response =
        conn
        |> put(Routes.users_path(conn, :update, params_to_update))
        |> json_response(:not_found)

      assert %{"message" => "User does not exists!"} == response
    end

    test "When the provided id is invalid, it returns an error message.", %{conn: conn} do
      params_to_update = %{
        "id" => "invalid_id_format",
        "email" => "updated_email@example.com",
        "password" => "supersenha",
        "currentPassword" => "supersenha"
      }

      response =
        conn
        |> put(Routes.users_path(conn, :update, params_to_update))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid id format!"} == response
    end
  end
end
