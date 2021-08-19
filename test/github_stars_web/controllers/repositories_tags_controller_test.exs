defmodule GithubStarsWeb.Controllers.RepositoriesTagsControllerTest do
  use GithubStarsWeb.ConnCase
  import Mock

  describe "tags/2" do
    test "When input is valid, list repository's tags (repo with no tags)", %{conn: conn} do
      params = %{repo_id: "1000"}

      response =
        conn
        |> get(Routes.repositories_tags_path(conn, :tags, 0, params))
        |> json_response(:ok)

      assert %{"data" => []} == response
    end

    test "When input is valid, list repository's tags (repo with tags)", %{conn: conn} do
      conn
      |> post(Routes.tags_path(conn, :create, %{repo_id: "1000", name: "elixir_tag"}))

      response =
        conn
        |> get(Routes.repositories_tags_path(conn, :tags, 1000, %{repo_id: "1000"}))
        |> json_response(:ok)

      assert %{"data" => [%{"name" => "elixir_tag"}]} = response
    end
  end
end
