defmodule GithubStarsWeb.Controllers.SuggestionsControllerTest do
  use GithubStarsWeb.ConnCase

  describe "index/2" do
    test "Suggest a list of tags", %{conn: conn} do
      response =
        conn
        |> get(Routes.suggestions_path(conn, :index, %{}))
        |> json_response(:ok)

      assert %{
               "data" => [
                 "api",
                 "json",
                 "xml",
                 "yaml",
                 "aws",
                 "gcp",
                 "elixir",
                 "javascript",
                 "c",
                 "java",
                 "python",
                 "node",
                 "typescript",
                 "web",
                 "poc",
                 "todo",
                 "deprecated"
               ]
             } = response
    end
  end
end
