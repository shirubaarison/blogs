defmodule Blog.Blogs do
  import Ecto.Query

  alias Blog.Repo
  alias Blog.Blogs.Post

  @valid_filters ["tags", "category", "term"]

  def get_all(filters \\ %{}) do
    filters
    |> Enum.filter(fn {key, _} -> key in @valid_filters end)
    |> Enum.reduce(Post, fn
      {"tags", value}, query -> from p in query, where: ^value in p.tags
      {"category", value}, query -> from p in query, where: p.category == ^value
      {"term", value}, query -> from p in query, where: ilike(p.title, ^"%#{value}%") or ilike(p.content, ^"%#{value}%")
    end)
    |> Repo.all()
  end

  def get(id), do: Repo.get(Post, id)

  def create(attrs, user_id) do
    %Post{user_id: user_id}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def delete(post_id, user_id) do
    post = Repo.get(Post, post_id)

    if post.user_id == user_id do
      Repo.delete(post)
      {:ok, "deleted"}
    else
      {:error, "can't delete something you don't own"}
    end
  end

  def update(attrs, user_id) do
    post = Repo.get(Post, attrs["id"])

    if post.user_id == user_id do
      changeset = Post.changeset(post, attrs)

      case Repo.update(changeset) do
        {:ok, updated_post} -> {:ok, updated_post}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, "can't update something you don't own"}
    end
  end
end
