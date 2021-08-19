defmodule GithubStars do
  alias GithubStars.Repositories.GetRepositories
  alias GithubStars.Tags.{CreateTags, EditTag, DeleteTag, GetTags}
  alias GithubStars.Suggestions.SuggestTags

  @moduledoc """
  GithubStars keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defdelegate get_repositories(params), to: GetRepositories, as: :call
  defdelegate get_tags(params), to: GetTags, as: :call
  defdelegate create_tags(params), to: CreateTags, as: :call
  defdelegate update_tag(params), to: EditTag, as: :call
  defdelegate delete_tag(params), to: DeleteTag, as: :call

  defdelegate suggest_tags(), to: SuggestTags, as: :call
end
