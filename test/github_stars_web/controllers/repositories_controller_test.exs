defmodule GithubStarsWeb.Controllers.RepositoriesControllerTest do
  use GithubStarsWeb.ConnCase
  import Mock

  alias GithubStars.Provider.Http.GithubBase

  describe "index/2" do
    test "When input is valid, list user repositories", %{conn: conn} do
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
        params = %{"username" => "bob"}

        response =
          conn
          |> get(Routes.user_repositories_path(conn, :index, 0, params))
          |> json_response(:ok)

        assert %{
                 "data" => [
                   %{
                     "description" => "desc",
                     "html_url" => "http://localhost",
                     "id" => 123,
                     "language" => "Elixir",
                     "name" => "name",
                     "tags" => []
                   }
                 ]
               } = response
      end
    end

    test "When input is valid, list user repositories and filter by tag", %{conn: conn} do
      params = %{repo_id: "2030", name: "label_tag", id: 100}

      response =
        conn
        |> post(Routes.tags_path(conn, :create, params))
        |> json_response(:created)

      %{
        "data" => %{"id" => id}
      } = response

      first_resp =
        {:ok,
         %HTTPoison.Response{
           body: "[{\"id\":2030}]",
           status_code: 200
         }}

      second_resp = %HTTPoison.Response{
        body:
          "{\"description\":\"desc\",\"name\":\"name\",\"id\":2030,\"html_url\":\"http://localhost\",\"language\":\"Elixir\"}",
        status_code: 200
      }

      with_mock GithubBase, get: fn _url -> first_resp end, get!: fn _url -> second_resp end do
        params = %{"username" => "bob", "tag" => "lab"}

        response =
          conn
          |> get(Routes.user_repositories_path(conn, :index, 0, params))
          |> json_response(:ok)

        assert %{
                 "data" => [
                   %{
                     "description" => "desc",
                     "html_url" => "http://localhost",
                     "id" => 2030,
                     "language" => "Elixir",
                     "name" => "name",
                     "tags" => ["label_tag"]
                   }
                 ]
               } = response
      end
    end
  end
end
