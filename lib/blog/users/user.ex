defmodule Blog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Blogs.Post

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "users" do
    field :username, :string
    field :full_name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true, redact: true

    has_many :posts, Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :full_name, :email, :password])
    |> validate_required([:username, :full_name, :email, :password])
    |> validate_email()
    |> validate_password()
    |> unique_constraint(:username)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

      _ -> changeset
    end
  end

  defp validate_email(changeset) do
    changeset
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "invalid e-mail")
    |> validate_length(:email, max: 160)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 255)
    |> validate_format(:password, ~r/[a-z]/, message: "must contain at least one lowercase letter")
    |> validate_format(:password, ~r/[A-Z]/, message: "must contain at least one uppercase letter")
    |> validate_format(:password, ~r/[0-9]/, message: "must contain at least one number")
  end
end
