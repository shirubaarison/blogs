defmodule BlogWeb.BlogController do
  use BlogWeb, :controller

  alias BlogWeb.AuthErrorHandler
  alias Blog.Blogs

  def index(conn, params) do
    posts = Blogs.get_all(params)

    conn
    |> put_status(:ok)
    |> render(:index, %{posts: posts})
  end

  def get_by_id(conn, %{"id" => post_id}) do
    case Ecto.UUID.cast(post_id) do
      {:ok, valid_uuid} ->
        case Blogs.get(valid_uuid) do
          nil ->
            send_resp(conn, :not_found, "")
          post ->
            conn
            |> put_status(:ok)
            |> render(:show, %{post: post})
        end
      _ ->
        conn
        |> put_status(:bad_request)
        |> render(:bad_request, %{error: "malformatted id"})
    end
  end

  def create(conn, %{"title" => _t, "content" => _c, "category" => _ca, "tags" => _ta} = params) do
    user = Guardian.Plug.current_resource(conn)

    case Blogs.create(params, user.id) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> render(:show, %{post: post})

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = AuthErrorHandler.translate_errors(changeset)
        conn
        |> put_status(:bad_request)
        |> json(%{
          errors: errors
        })
    end
  end

  def delete(conn, %{"id" => post_id}) do
    user = Guardian.Plug.current_resource(conn)

    case Blogs.delete(post_id, user.id) do
      {:ok, _msg} ->
        conn
        |> send_resp(:no_content, "")
      {:error, _reason} ->
        conn
        |> send_resp(:bad_request, "")
    end
  end

  def put(conn, %{"id" => _id, "title" => _t, "content" => _c, "category" => _ca, "tags" => _ta} = params) do
    user = Guardian.Plug.current_resource(conn)

    case Blogs.update(params, user.id) do
      {:ok, post} ->
        conn
        |> render(:show, %{post: post})

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = AuthErrorHandler.translate_errors(changeset)
        conn
        |> put_status(:bad_request)
        |> json(%{
          errors: errors
        })
    end
  end

end
