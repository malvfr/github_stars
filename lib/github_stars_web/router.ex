defmodule GithubStarsWeb.Router do
  use GithubStarsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1/", GithubStarsWeb do
    pipe_through :api

    get "/users/:username/repositories", UserRepositoriesController, :index
    get "/repositories/:repo_id/tags", RepositoriesTagsController, :tags
    get "/suggestions", SuggestionsController, :index
    post "/tags", TagsController, :create
    put "/tags/:id", TagsController, :update
    delete "/tags/:id", TagsController, :remove
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :github_stars,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "GithubStars"
      }
    }
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: GithubStarsWeb.Telemetry
    end
  end
end
