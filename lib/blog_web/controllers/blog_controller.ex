defmodule BlogWeb.BlogController do
  use BlogWeb, :controller

  alias BlogWeb.AuthErrorHandler
  alias Blog.Blogs

  def get_all(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(
      Blogs.get_all()
    )
  end

  def create(conn, %{"title" => _t, "content" => _c, "category" => _ca, "tags" => _ta} = params) do
    user = Guardian.Plug.current_resource(conn)

    case Blogs.create(params, user.id) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> json(post)

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
