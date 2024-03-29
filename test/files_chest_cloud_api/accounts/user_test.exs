defmodule FilesChestCloudApi.Accounts.UserTest do
  use FilesChestCloudApi.DataCase

  alias FilesChestCloudApi.Accounts.User

  describe "changeset/2" do
    test "When all params to create user are valid, returns a valid changeset." do
      params = %{
        name: "Guigo",
        email: "guigo.test@example.com",
        password: "supersenha"
      }

      response = User.changeset(%User{}, params)

      assert %Ecto.Changeset{valid?: true} = response
    end

    test "When the name is not provided, it returns an error message." do
      params = %{
        name: "",
        email: "guigo.test@example.com",
        password: "supersenha"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{name: ["can't be blank"]}
    end

    test "When the given name has less than two characters, it returns an error message." do
      params = %{
        name: "G",
        email: "guigo.test@example.com",
        password: "supersenha"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{name: ["should be at least 2 character(s)"]}
    end

    test "When the name has more than 50 characters, it returns an error message." do
      params = %{
        name: "José João Guilherme Barrichello Senna Silva",
        email: "guigo.test@example.com",
        password: "supersenha"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{name: ["should be at most 40 character(s)"]}
    end

    test "When the email is not provided, it returns an error message." do
      params = %{
        name: "Guigo",
        email: "",
        password: "supersenha"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{email: ["can't be blank"]}
    end

    test "When the given email has less than ten characters, it returns an error message." do
      params = %{
        name: "Guigo",
        email: "@gmail.com",
        password: "supersenha"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{email: ["should be at least 11 character(s)"]}
    end

    test "When the email contains more than 40 characters, it returns an error." do
      params = %{
        name: "Guigo",
        email: "um-endereco-de-email-longoooo@outlook.com",
        password: "supersenha"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{email: ["should be at most 40 character(s)"]}
    end

    test "When the email format is invalid, it returns an error message." do
      params = %{
        name: "Guigo",
        email: "guigo.testexample.com",
        password: "supersenha"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{email: ["has invalid format"]}
    end

    test "When the password is not provided, it returns an error message." do
      params = %{
        name: "Guigo",
        email: "guigo.test@example.com",
        password: ""
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{password: ["can't be blank"]}
    end

    test "When the provided password is less than six characters long, it returns an error message." do
      params = %{
        name: "Guigo",
        email: "guigo.test@example.com",
        password: "12345"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{password: ["should be at least 6 character(s)"]}
    end

    test "When the provided password contains more than 30 characters, it returns an error." do
      params = %{
        name: "Guigo",
        email: "guigo.test@example.com",
        password: "45a23a4f-4a9d-4035-9071-8dba94205d50"
      }

      response = User.changeset(%User{}, params)

      assert errors_on(response) == %{password: ["should be at most 30 character(s)"]}
    end
  end
end
