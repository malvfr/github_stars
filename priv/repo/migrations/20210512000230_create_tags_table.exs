defmodule GithubStars.Repo.Migrations.CreateTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string, null: false
      add :repo_id, :integer, null: false

      timestamps()
    end
  end
end
