defmodule Blog.Blogs do
  alias Blog.Repo
  alias Blog.Blogs.Post

  def get_all(), do: Repo.all(Post)

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
end
