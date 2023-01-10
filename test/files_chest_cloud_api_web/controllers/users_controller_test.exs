defmodule FilesChestCloudApiWeb.UsersControllerTest do
  use FilesChestCloudApiWeb.ConnCase

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
end
