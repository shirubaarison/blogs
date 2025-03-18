defmodule Blog.Blogs.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :content, :category, :tags, :user_id]}

  schema "posts" do
    field :title, :string
    field :content, :string
    field :category, :string
    field :views, :integer, default: 0
    field :tags, {:array, :string}
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :category, :tags, :user_id])
    |> validate_required([:title, :content, :user_id])
  end
end
