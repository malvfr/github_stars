defmodule GithubStars.Provider.Http.GithubBase do
  @moduledoc """
   Defines the base of Github API. Sets default headers, Api's URL and HTTP timeout"
  """
  use HTTPoison.Base

  @github_auth Application.fetch_env!(:github_stars, :github_auth)

  @default_headers [
    # For practical reasons, we are hard coding the token. We could retrieve the token via user request headers or use the system environment
    {"Authorization", @github_auth},
    {"Content-Type", "application/json"},
    {"charset", "UTF-8"},
    {"Connection", "keep-alive"}
  ]

  @doc """
    Concatenates the Github base api URI with the provided resource path
  """
  def process_request_url(url) do
    "https://api.github.com" <> url
  end

  @doc """
   Adds headers to the request
  """
  def process_request_headers(headers) do
    @default_headers ++ headers
  end

  @doc """
   Processes the request and set default http timeout
  """
  def process_request_options(options) do
    [timeout: 50_000, recv_timeout: 50_000] ++ options
  end
end
