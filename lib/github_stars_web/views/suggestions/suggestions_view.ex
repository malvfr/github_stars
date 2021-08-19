defmodule GithubStarsWeb.Suggestions.SuggestionsView do
  use GithubStarsWeb, :view

  def render("index.json", %{tags: tags}) do
    %{
      data: tags
    }
  end
end
