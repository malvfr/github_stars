defmodule GithubStarsWeb.TagsController do
  use GithubStarsWeb, :controller

  alias GithubStarsWeb.FallbackController
  alias GithubStarsWeb.Tags.TagsView
  alias GithubStars.Tags.Tag

  use PhoenixSwagger

  action_fallback FallbackController

  swagger_path :create do
    post("/api/v1/tags")
    summary("Creates a tag for the provided repository")
    description("Creates a tag for the provided repository")
    produces("application/json")
    tag("Tag")
    operation_id("create_tag")

    parameters do
      user(:body, Schema.ref(:TagBody), "tag attributes")
    end

    response(201, "Created", Schema.ref(:Tag))
    response(400, "Bad request")
  end

  def create(conn, params) do
    with {:ok, %Tag{} = tag} <- GithubStars.create_tags(params) do
      conn
      |> put_status(:created)
      |> put_view(TagsView)
      |> render("create.json", tag: tag)
    end
  end

  swagger_path :update do
    put("/api/v1/tags/{tag_id}")
    summary("Updates a tag for the provided repository")
    description("Updates a tag for the provided repository")
    produces("application/json")
    tag("Tag")
    operation_id("update_tag")

    parameters do
      tag_attrs(:body, Schema.ref(:TagBody), "tag attributes")
      tag_id(:path, :string, "Tag ID", required: true, example: "123")
    end

    response(204, "No content")
    response(400, "Bad request")
  end

  def update(conn, params) do
    with :ok <- GithubStars.update_tag(params) do
      conn
      |> send_resp(:no_content, "")
    end
  end

  swagger_path :remove do
    delete("/api/v1/tags/{tag_id}")
    summary("Deletes a tag")
    description("Deletes a tag")
    produces("application/json")
    tag("Tag")
    operation_id("delete_tag")

    parameters do
      user(:body, Schema.ref(:TagBody), "tag attributes")
      tag_id(:path, :string, "Tag ID", required: true, example: "123")
    end

    response(204, "No content")
    response(400, "Bad request")
  end

  def remove(conn, params) do
    with :ok <- GithubStars.delete_tag(params) do
      conn
      |> send_resp(:no_content, "")
    end
  end

  def swagger_definitions do
    %{
      Tag:
        swagger_schema do
          title("Repository tag")
          description("Repository tag")

          properties do
            data(
              Schema.new do
                properties do
                  id(:integer, "id")
                  repo_id(:integer, "repo_id")
                  name(:integer, "name")
                end
              end
            )
          end
        end,
      TagBody:
        swagger_schema do
          title("Tag attributes")
          description("Tag attributes")

          properties do
            name(:string, "Tag name")
            repo_id(:integer, "Repository ID")
          end
        end
    }
  end
end
