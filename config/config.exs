# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :github_stars,
  ecto_repos: [GithubStars.Repo],
  github_auth: System.get_env("GITHUB_AUTH") || ""

# Configures the endpoint
config :github_stars, GithubStarsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6ooGzJV2Hgs1tov1REc4rCqDA2UAeBS+bArbk9EavKwYCCeCzG3NJpRvMzVJXPtu",
  render_errors: [view: GithubStarsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GithubStars.PubSub,
  live_view: [signing_salt: "xGHLNH57"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Config swagger

config :github_stars, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: GithubStarsWeb.Router
    ]
  }

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix_swagger, json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :github_stars, GithubStarsWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg|json)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/your_app_web/views/.*(ex)$},
      ~r{lib/your_app_web/controllers/.*(ex)$},
      ~r{lib/your_app_web/templates/.*(eex)$}
    ]
  ],
  reloadable_compilers: [:gettext, :phoenix, :elixir, :phoenix_swagger]
