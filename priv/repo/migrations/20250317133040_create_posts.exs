defmodule Blog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :title, :string
      add :views, :integer
      add :content, :text
      add :category, :text
      add :tags, {:array, :string}
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:posts, [:user_id])
  end
end
