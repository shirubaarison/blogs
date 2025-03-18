defmodule BlogWeb.BlogController do
  use BlogWeb, :controller

  alias BlogWeb.AuthErrorHandler
  alias Blog.Blogs

  def get_all(conn, _params) do
    conn
    |> put_status(:ok)
    |> render(:index, %{posts: Blogs.get_all()})
  end

  def get_by_id(conn, %{"id" => post_id}) do
    with {id, ""} <- Integer.parse(post_id),
         post when not is_nil(post) <- Blogs.get(id) do
      conn
      |> put_status(:ok)
      |> render(:show, %{post: post})
    else
      _ ->
        send_resp(conn, :not_found, "")
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
