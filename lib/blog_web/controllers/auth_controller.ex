defmodule BlogWeb.AuthController do
  use BlogWeb, :controller

  alias BlogWeb.AuthErrorHandler
  alias Blog.Users
  alias Blog.Guardian

  def login(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:ok)
        |> json(%{
          token: token
        })

      {:error, _} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  def signup(conn, %{"username" => _u, "full_name" => _n, "email" => _e, "password" => _p} = params) do
    case Users.register_user(params) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:created)
        |> json(%{
          token: token,
          user_id: user.id
        })

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = AuthErrorHandler.translate_errors(changeset)
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors: errors
        })
    end
  end
end
