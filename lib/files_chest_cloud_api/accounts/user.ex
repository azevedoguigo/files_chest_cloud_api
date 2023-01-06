defmodule FilesChestCloudApi.Accounts.User do
  @moduledoc """
  This module provides the schema and user changeset.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @required_fields [:name, :email, :password]

  @derive {Jason.Encoder, only: [:id, :name, :email, :inserted_at]}
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
    |> unique_constraint(:email, name: :users_email_index)
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end
  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
