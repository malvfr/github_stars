defmodule GithubStars.Tags.DeleteTag do
  @moduledoc """
   Defines the DeleteTag operation module
  """

  alias GithubStars.Tags.Tag
  alias GithubStars.Repo

  import Logger

  @doc """
    Deletes a tag in the local database.
  """
  def call(%{"id" => id}) do
    Logger.info("Deleting tag with id #{inspect(id)}")

    with {:ok, tag} <- handle_get(Repo.get(Tag, id)),
         {:ok, _} <- Repo.delete(tag) do
      :ok
    else
      :error -> {:error, %{result: "Not found", status: 404}}
      {:error, changeset} -> {:error, %{result: changeset, status: 500}}
    end
  end

  defp handle_get(ret) when is_nil(ret) do
    Logger.info("Tag not found #{inspect(ret)}")
    :error
  end

  defp handle_get(ret) do
    Logger.info("Tag found #{inspect(ret)}")
    {:ok, ret}
  end
end
