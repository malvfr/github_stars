defmodule GithubStars.Repositories.GetRepositoriesTest do
  use ExUnit.Case
  use GithubStarsWeb.ConnCase

  import Mock

  alias GithubStars.Provider.Http.Github.Repositories
  alias GithubStars.Repositories.GetRepositories

  describe "call/1" do
    test "Get starred repositories for a given user without tags" do
      first_resp =
        {:ok,
         [
           %{
             "description" => "desc - 1",
             "html_url" => "http://localhost:repo1",
             "id" => 1000,
             "language" => "Elixir",
             "name" => "ElixirName"
           },
           %{
             "description" => "desc - 2",
             "html_url" => "http://localhost:repo2",
             "id" => 2000,
             "language" => "Typescript",
             "name" => "TsName"
           }
         ]}

      with_mock Repositories,
        get_starred_repositories: fn _username -> first_resp end,
        get_repository: fn id ->
          Enum.find(elem(first_resp, 1), fn elm -> elm["id"] == id end)
        end do
        assert {:ok,
                [
                  %{
                    "description" => "desc - 1",
                    "html_url" => "http://localhost:repo1",
                    "id" => 1000,
                    "language" => "Elixir",
                    "name" => "ElixirName",
                    "tags" => []
                  },
                  %{
                    "description" => "desc - 2",
                    "html_url" => "http://localhost:repo2",
                    "id" => 2000,
                    "language" => "Typescript",
                    "name" => "TsName",
                    "tags" => []
                  }
                ]} ==
                 GithubStars.get_repositories(%{"username" => "user"})
      end
    end

    test "Get starred repositories for a given user and apply tags", %{conn: conn} do
      params = %{repo_id: "1000", name: "elixir_tag"}

      conn
      |> post(Routes.tags_path(conn, :create, params))

      first_resp =
        {:ok,
         [
           %{
             "description" => "desc - 1",
             "html_url" => "http://localhost:repo1",
             "id" => 1000,
             "language" => "Elixir",
             "name" => "ElixirName"
           },
           %{
             "description" => "desc - 2",
             "html_url" => "http://localhost:repo2",
             "id" => 2000,
             "language" => "Typescript",
             "name" => "TsName"
           }
         ]}

      with_mock Repositories,
        get_starred_repositories: fn _username -> first_resp end,
        get_repository: fn id ->
          Enum.find(elem(first_resp, 1), fn elm -> elm["id"] == id end)
        end do
        assert {:ok,
                [
                  %{
                    "description" => "desc - 1",
                    "html_url" => "http://localhost:repo1",
                    "id" => 1000,
                    "language" => "Elixir",
                    "name" => "ElixirName",
                    "tags" => ["elixir_tag"]
                  },
                  %{
                    "description" => "desc - 2",
                    "html_url" => "http://localhost:repo2",
                    "id" => 2000,
                    "language" => "Typescript",
                    "name" => "TsName",
                    "tags" => []
                  }
                ]} ==
                 GithubStars.get_repositories(%{"username" => "user"})
      end
    end
  end
end
