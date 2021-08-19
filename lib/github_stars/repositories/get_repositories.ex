defmodule GithubStars.Repositories.GetRepositories do
  @moduledoc """
   Operations with local tags and github's repositories.
  """
  alias GithubStars.Provider.Http.Github.Repositories, as: GitRepos
  alias GithubStars.Tags.Tag
  alias GithubStars.Repo

  import Ecto.Query

  @doc """
  Filters the repositories with given `tag`.

  ## Parameters

  • %{"tag" => tag}: String with the tag label.

  ## Examples

      iex> GetRepositories.call(%{"tag" => "elixir"})

  """
  def call(%{"tag" => tag}) do
    get_by_tag(tag)
  end

  @doc """
  Filters the repositories for the given user.

  ## Parameters

  • %{"username" => username}: String representing the user's name

  ## Examples

      iex> GetRepositories.call(%{"username" => "username"})

  """
  def call(%{"username" => username}) do
    case GitRepos.get_starred_repositories(username) do
      [] -> {:error, %{status: :not_found}}
      result -> apply_tags(result)
    end
  end

  defp get_by_tag(tag) do
    query_ids =
      from t in Tag,
        where: ilike(t.name, ^"%#{tag}%"),
        select: t.repo_id,
        distinct: true

    repo_ids = Repo.all(query_ids)

    data = Enum.map(repo_ids, fn repo_id -> get_tags_by_repo_id(repo_id) end)

    {:ok, data}
  end

  defp get_tags_by_repo_id(id) do
    tags = Repo.all(from t in Tag, where: t.repo_id == ^id, select: t.name)

    GitRepos.get_repository(id) |> Map.put("tags", tags)
  end

  defp apply_tags({:ok, repos}) do
    tags = Enum.map(repos, fn repo -> get_tags_by_repo_id(repo["id"]) end)
    {:ok, tags}
  end

  defp apply_tags({:error, reason}) do
    {:error, reason}
  end
end
