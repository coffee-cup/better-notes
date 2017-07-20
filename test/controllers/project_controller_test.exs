defmodule BetterNotes.ProjectControllerTest do
  use BetterNotes.ConnCase

  alias BetterNotes.User
  alias BetterNotes.Project

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! User.changeset(%User{}, %{
      auth_provider: "some content",
      avatar: "some content",
      email: "some content",
      first_name: "some content",
      last_name: "some content"
    })
    {:ok, conn: conn |> guardian_login(user)}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! Project.changeset(%Project{user_id: conn.assigns.user_id}, @valid_attrs)
    conn = get conn, project_path(conn, :show, project)
    assert json_response(conn, 200) == %{"id" => project.id,
      "name" => project.name,
      "user_id" => conn.assigns.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, project_path(conn, :show, -1)
    assert response(conn, 404)
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), @valid_attrs
    assert json_response(conn, 201)["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), @invalid_attrs
    assert response(conn, 400)
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project = Repo.insert! Project.changeset(%Project{user_id: conn.assigns.user_id}, @valid_attrs)
    conn = put conn, project_path(conn, :update, project), @valid_attrs
    assert json_response(conn, 200)["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! Project.changeset(%Project{user_id: conn.assigns.user_id}, @valid_attrs)
    conn = put conn, project_path(conn, :update, project), @invalid_attrs
    assert response(conn, 400)
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! Project.changeset(%Project{user_id: conn.assigns.user_id}, @valid_attrs)
    conn = delete conn, project_path(conn, :delete, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end

  test "other user does not have access to project", %{conn: conn} do
    project = Repo.insert! Project.changeset(%Project{user_id: conn.assigns.user_id}, @valid_attrs)
    user = Repo.insert! %User{}
    conn = guardian_login(conn, user)

    conn = get conn, project_path(conn, :show, project)
    assert response(conn, 404)
  end
end
