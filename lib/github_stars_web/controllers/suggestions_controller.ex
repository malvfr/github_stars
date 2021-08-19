defmodule GithubStarsWeb.SuggestionsController do
  use GithubStarsWeb, :controller

  alias GithubStarsWeb.FallbackController
  alias GithubStarsWeb.Suggestions.SuggestionsView

  use PhoenixSwagger

  action_fallback FallbackController

  swagger_path :index do
    get("/api/v1/suggestions")
    summary("New tags suggestion")
    description("New tags suggestion")
    produces("application/json")
    tag("Suggestions")
    operation_id("suggest_tags")

    response(201, "OK", Schema.array(:string))
  end

  def index(conn, _params) do
    tags = GithubStars.suggest_tags()

    conn
    |> put_status(:ok)
    |> put_view(SuggestionsView)
    |> render("index.json", tags: tags)
  end
end
