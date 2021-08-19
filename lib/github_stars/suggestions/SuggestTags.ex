defmodule GithubStars.Suggestions.SuggestTags do
  @moduledoc """
    Returns a list of suggested tags
  """
  def call() do
    ~w(api json xml yaml aws gcp elixir javascript c java python node typescript web poc todo deprecated)
  end
end
