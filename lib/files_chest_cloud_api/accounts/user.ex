defmodule FilesChestCloudApi.Accounts.User do
  @moduledoc """
  This module provides the schema and user changeset.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @required_fields [:name, :email, :password]

  @derive {Jason.Encoder, only: [:id, :name, :email, :inserted_at, :updated_at]}
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 2, max: 40)
    |> validate_length(:email, min: 11, max: 40)
    |> validate_length(:password, min: 6, max: 30)
    |> unique_constraint(:email, name: :users_email_index)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Argon2.hash_pwd_salt(password)})
  end

  defp put_password_hash(changeset), do: changeset
end
