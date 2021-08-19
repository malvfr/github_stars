defmodule GithubStars.Repo do
  use Ecto.Repo,
    otp_app: :github_stars,
    adapter: Ecto.Adapters.Postgres
end
