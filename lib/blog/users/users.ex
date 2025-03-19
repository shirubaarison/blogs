defmodule Blog.Users do
  alias Blog.Repo
  alias Blog.Users.User

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def get_user!(id), do: Repo.get_by(User, id: id)

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil -> {:error, :invalid_credentials}
      user ->
        case Bcrypt.verify_pass(password, user.password_hash) do
          true -> {:ok, user}
          _ -> {:error, :invalid_credentials}
      end
    end
  end

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
