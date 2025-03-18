defmodule Blog.Blogs do
  alias Blog.Repo
  alias Blog.Blogs.Post

  def get_all(), do: Repo.all(Post)

  def create(attrs, user_id) do
    %Post{user_id: user_id}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end
end
