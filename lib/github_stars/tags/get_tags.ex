defmodule GithubStars.Tags.GetTags do
  @moduledoc """
   Defines the GetTags operation module
  """
  alias GithubStars.Tags.Tag
  alias GithubStars.Repo

  import Ecto.Query
  import Logger

  @doc """
    Fetches tags in the local database for the given repository.
  """
  def call(%{"repo_id" => repo_id}) do
    Logger.debug("Listing all tags with params: #{inspect(repo_id)}")

    query = from t in Tag, where: t.repo_id == ^repo_id, select: %{name: t.name, id: t.id}

    result = Repo.all(query)

    {:ok, result}
  end
end
