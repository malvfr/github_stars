defmodule GithubStarsWeb.RepositoriesController do
  use GithubStarsWeb, :controller

  alias GithubStarsWeb.FallbackController
  alias GithubStarsWeb.Repositories.RepositoriesView
  use PhoenixSwagger

  action_fallback FallbackController

  swagger_path :index do
    get("/api/v1/repositories/{username}")
    summary("Query for repositories")
    description("List repositories which the provided user have")
    produces("application/json")
    tag("Repositories")
    operation_id("list_repositories")

    parameters do
      username(:path, :string, "Github username", required: true, example: "user1")
      tag(:query, :string, "Tag label", required: false, example: "bob")
    end

    response(200, "OK", Schema.ref(:Repositories))
    response(404, "NOT FOUND")
  end

  def index(conn, params) do
    with {:ok, repositories} <- GithubStars.get_repositories(params) do
      conn
      |> put_status(:ok)
      |> put_view(RepositoriesView)
      |> render("index.json", repositories: repositories)
    end
  end

  def swagger_definitions do
    %{
      Repositories:
        swagger_schema do
          title("Repositories")
          description("A user of the application")

          properties do
            data(Schema.array(:Repository))
          end
        end,
      Repository:
        swagger_schema do
          title("Repository")
          description("Repository")

          properties do
            description(:string, "description")
            html_url(:string, "html_url")
            id(:integer, "id")
            language(:string, "description")

            tags(Schema.array(:string))
          end
        end,
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
