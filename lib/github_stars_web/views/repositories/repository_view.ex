defmodule GithubStarsWeb.Repositories.RepositoriesView do
  use GithubStarsWeb, :view

  def render("index.json", %{repositories: repositories}) do
    %{
      data: repositories
    }
  end

  def render("tags.json", %{tags: tags}) do
    %{
      data: tags
    }
  end
end
