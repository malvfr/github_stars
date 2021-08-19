defmodule GithubStars.Providers.Github.RepositoriesTest do
  use ExUnit.Case
  import Mock

  alias GithubStars.Provider.Http.GithubBase
  alias GithubStars.Provider.Http.Github.Repositories, as: Github

  describe "get_starred_repositories/1" do
    test "Get starred repositories for given user" do
      first_resp =
        {:ok,
         %HTTPoison.Response{
           body: "[{\"id\":123}]",
           status_code: 200
         }}

      second_resp = %HTTPoison.Response{
        body:
          "{\"description\":\"desc\",\"name\":\"name\",\"id\":123,\"html_url\":\"http://localhost\",\"language\":\"Elixir\"}",
        status_code: 200
      }

      with_mock GithubBase, get: fn _url -> first_resp end, get!: fn _url -> second_resp end do
        assert {:ok,
                [
                  %{
                    "description" => "desc",
                    "html_url" => "http://localhost",
                    "id" => 123,
                    "language" => "Elixir",
                    "name" => "name"
                  }
                ]} == Github.get_starred_repositories("username")
      end
    end

    test "Get starred repositories for given user when input is invalid (User does not exist)" do
      error_resp =
        {:ok,
         %HTTPoison.Response{
           body: "[{\"dummy\":\"dummy\"}]",
           status_code: 404
         }}

      with_mock GithubBase, get: fn _url -> error_resp end do
        assert {:error, :not_found} = Github.get_starred_repositories("username")
      end
    end
  end
end
