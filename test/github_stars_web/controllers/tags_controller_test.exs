defmodule GithubStarsWeb.Controllers.TagsControllerTest do
  use GithubStarsWeb.ConnCase

  describe "create/2" do
    test "When input is valid, create tag", %{conn: conn} do
      params = %{repo_id: "2030", name: "label_tag", id: 100}

      response =
        conn
        |> post(Routes.tags_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "data" => %{"id" => _id, "name" => "label_tag", "repo_id" => 2030}
             } = response
    end

    test "When create input is invalid, return errors", %{conn: conn} do
      params = %{repo_id: "2030"}

      response =
        conn
        |> post(Routes.tags_path(conn, :create, params))
        |> json_response(:bad_request)

      assert response == %{"Message" => %{"name" => ["can't be blank"]}}
    end

    test "When create input is a duplicated tag, return errors", %{conn: conn} do
      params = %{repo_id: "1900", name: "old_tag", id: 100}

      conn
      |> post(Routes.tags_path(conn, :create, params))
      |> json_response(:created)

      params = %{name: "old_tag", id: 5, repo_id: "1900"}

      response =
        conn
        |> post(Routes.tags_path(conn, :create, params))
        |> json_response(:bad_request)

      assert response == %{"Message" => "Existent tag!"}
    end
  end

  describe "update/2" do
    test "When input is valid, update tag", %{conn: conn} do
      params = %{repo_id: "2030", name: "new_edited_tag"}

      conn
      |> put(Routes.tags_path(conn, :update, 1, params))
      |> response(:no_content)
    end

    test "When update input is invalid, return errors", %{conn: conn} do
      params = %{name: "new_edited_tag", id: "1"}

      response =
        conn
        |> put(Routes.tags_path(conn, :update, 1, params))
        |> json_response(:bad_request)

      assert response == %{"Message" => %{"repo_id" => ["can't be blank"]}}
    end

    test "When update input is a duplicated tag, return errors", %{conn: conn} do
      params = %{repo_id: "1900", name: "old_tag", id: 100}

      conn
      |> post(Routes.tags_path(conn, :create, params))
      |> json_response(:created)

      params = %{name: "old_tag", id: 5, repo_id: "1900"}

      response =
        conn
        |> put(Routes.tags_path(conn, :update, 1, params))
        |> json_response(:bad_request)

      assert response == %{"Message" => "Existent tag!"}
    end
  end

  describe "delete/2" do
    test "When input is valid, delete tag", %{conn: conn} do
      params = %{repo_id: "2030", name: "label_tag", id: 100}

      tag =
        conn
        |> post(Routes.tags_path(conn, :create, params))
        |> json_response(:created)

      %{"data" => %{"id" => id}} = tag

      conn
      |> delete(Routes.tags_path(conn, :remove, id))
      |> response(:no_content)
    end

    test "When input is invalid, output error", %{conn: conn} do
      conn
      |> delete(Routes.tags_path(conn, :remove, 123))
      |> json_response(:not_found)
    end
  end
end
