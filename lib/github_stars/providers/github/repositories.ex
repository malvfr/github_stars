defmodule GithubStars.Provider.Http.Github.Repositories do
  @moduledoc """
   Provides repositories operations for the Github API
  """

  alias GithubStars.Provider.Http.GithubBase, as: Github

  @repo_fields ~w(
    description name id html_url language
  )

  defp get_starred_repositories_id(username) do
    case Github.get("/users/#{username}/starred?per_page=1000") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body |> Jason.decode!() |> Enum.map(fn elm -> elm["id"] end)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :not_found}
    end
  end

  @doc """
  Gets the repositories for the user with given `username`.

  ## Parameters

  • username: String that represents the user's github name.

  ## Examples

      iex> Repositories.get_starred_repositories_id("john")
      {:ok, data}

  """
  def get_starred_repositories(username) do
    case get_starred_repositories_id(username) do
      {:ok, id_list} ->
        tasks =
          id_list
          |> Task.async_stream(fn id -> get_repository(id) end,
            timeout: 60_000
          )

        repos = tasks |> Enum.map(fn {:ok, elm} -> Map.take(elm, @repo_fields) end)

        {:ok, repos}

      {:error, resp} ->
        {:error, resp}
    end
  end

  @doc """
  Gets the specified repository with given `id`.

  ## Parameters

  • id: Integer that represents the repository identifier.

  ## Examples

      iex> Repositories.get_repository(1000)
      data

  """
  def get_repository(id) do
    Github.get!("/repositories/#{id}").body |> Jason.decode!() |> Map.take(@repo_fields)
  end
end
