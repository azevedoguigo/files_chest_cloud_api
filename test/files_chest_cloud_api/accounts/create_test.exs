defmodule FilesChestCloudApi.Accounts.CreateTest do
  use FilesChestCloudApi.DataCase

  alias FilesChestCloudApi.Accounts
  alias FilesChestCloudApi.Repo

  describe "register_user/1" do
    test "When all parameters are valid, it registers the user." do
      params = %{
        name: "Guigo",
        email: "guigo.test@example.com",
        password: "supersenha"
      }

      count_before = Repo.aggregate(Accounts.User, :count)

      response = Accounts.Create.register_user(params)

      count_after = Repo.aggregate(Accounts.User, :count)

      assert {:ok, %Accounts.User{name: "Guigo", email: "guigo.test@example.com"}} = response
      assert count_after > count_before
    end

    test "When any of the parameters are valid, it returns an error message." do
      params = %{
        name: "",
        email: "guigo.test@example.com",
        password: "supersenha"
      }

      {:error, changeset} = Accounts.Create.register_user(params)

      assert errors_on(changeset) == %{name: ["can't be blank"]}
    end
  end
end
