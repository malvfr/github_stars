defmodule GithubStarsWeb.Tags.TagsView do
  use GithubStarsWeb, :view

  def render("create.json", %{tag: tag}) do
    %{
      data: tag
    }
  end
end
