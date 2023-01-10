defmodule FilesChestCloudApiWeb.UsersControllerTest do
  use FilesChestCloudApiWeb.ConnCase

  alias FilesChestCloudApi.Accounts

  @user_default_params %{
    name: "Guigo",
    email: "guigo.test@example.com",
    password: "supersenha"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
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
      Accounts.Create.register_user(@user_default_params)

      credentials = %{email: "guigo.test@example.com", password: "supersenha"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, credentials))
        |> json_response(:ok)

      %{"token" => token} = response
      assert %{"token" => token} == response
    end

    test "When the email is invalid, it returns an error message.", %{conn: conn} do
      Accounts.Create.register_user(@user_default_params)

      credentials = %{email: "wrong_email@example.com", password: "supersenha"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, credentials))
        |> json_response(:unauthorized)

      assert %{"message" => "Email not registred!"} == response
    end

    test "When the password is invalid, it returns an error message.", %{conn: conn} do
      Accounts.Create.register_user(@user_default_params)

      credentials = %{email: "guigo.test@example.com", password: "wrong_password"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, credentials))
        |> json_response(:unauthorized)

      assert %{"message" => "Password invalid!"} == response
    end
  end
end