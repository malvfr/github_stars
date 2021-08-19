defmodule GithubStarsWeb.RepositoriesTagsController do
  use GithubStarsWeb, :controller

  alias GithubStarsWeb.FallbackController
  alias GithubStarsWeb.Repositories.RepositoriesView
  use PhoenixSwagger

  action_fallback FallbackController

  swagger_path :tags do
    get("/api/v1/repositories/{repo_id}/tags")
    summary("Query for tags in the specific repo")
    description("List tags of that repository")
    produces("application/json")
    tag("RepositoriesTags")
    operation_id("list_repository_tags")

    parameters do
      repo_id(:path, :integer, "Repository id", required: true)
    end

    response(200, "OK", Schema.ref(:Repository_tags))
    response(404, "NOT FOUND")
  end

  def tags(conn, params) do
    with {:ok, tags} <- GithubStars.get_tags(params) do
      conn
      |> put_status(:ok)
      |> put_view(RepositoriesView)
      |> render("tags.json", tags: tags)
    end
  end

  def swagger_definitions do
    %{
      Repository_tags:
        swagger_schema do
          title("Repository tags")
          description("Repository tags")

          properties do
            data(Schema.array(:Tag))
          end
        end,
      Tag:
        swagger_schema do
          title("Repository tag")
          description("Repository tag")

          properties do
            id(:integer, "id")
            name(:integer, "name")
          end
        end
    }
  end
end
