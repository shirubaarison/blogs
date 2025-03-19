defmodule BlogWeb.BlogJSON do
  alias Blog.Blogs.Post

  def index(%{posts: posts}) do
    %{posts: for(post <- posts, do: data(post))}
  end

  def show(%{post: post}) do
    %{post: data(post)}
  end

  def bad_request(%{error: error}) do
    %{error: error}
  end

  defp data(%Post{} = post) do
    %{
      id: post.id,
      title: post.title,
      content: post.content,
      category: post.category,
      tags: post.tags,
      views: post.views,
      createdAt: post.inserted_at,
      updatedAt: post.updated_at
    }
  end
end
