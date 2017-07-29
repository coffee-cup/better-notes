defmodule BetterNotes.NoteControllerTest do
  use BetterNotes.ConnCase

  alias BetterNotes.User
  alias BetterNotes.Project
  alias BetterNotes.Note

  @valid_attrs %{html: "some content", text: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! User.changeset(%User{}, %{
      auth_provider: "some content",
      avatar: "some content",
      email: "some content",
      first_name: "some content",
      last_name: "some content"
    })
    project = Repo.insert! Project.changeset(%Project{user_id: user.id}, %{
      name: "some content"
    })
    {:ok, conn: conn |> guardian_login(user), project: project}
  end

  test "lists all entries on index", %{conn: conn, project: project} do
    conn = get conn, note_path(conn, :index, project.id)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn, project: project} do
    note = Repo.insert! Note.changeset(%Note{project_id: project.id}, @valid_attrs)
    conn = get conn, note_path(conn, :show, project, note)
    assert json_response(conn, 200) == %{"id" => note.id,
      "project_id" => note.project_id,
      "text" => note.text,
      "html" => note.html}
  end

  test "another user is unauthorized to access a note that isn't theirs", %{conn: conn} do
    user = Repo.insert! User.changeset(%User{}, %{
      auth_provider: "some content 2",
      avatar: "some content 2",
      email: "some content 2",
      first_name: "some content 2",
      last_name: "some content 2"
    })
    project2 = Repo.insert! Project.changeset(%Project{user_id: user.id}, %{
      name: "some content"
    })
    note = Repo.insert! Note.changeset(%Note{project_id: project2.id}, @valid_attrs)

    conn = get conn, note_path(conn, :show, project2, note)
    assert response(conn, 401)
  end

  test "renders page not found when id is nonexistent", %{conn: conn, project: project} do
    get conn, note_path(conn, :show, project, -1)
  end

  test "creates and renders resource when data is valid", %{conn: conn, project: project} do
    conn = post conn, note_path(conn, :create, project), @valid_attrs
    assert json_response(conn, 201)["id"]
    assert Repo.get_by(Note, %{text: Map.get(@valid_attrs, :text)})
  end

  test "does not create note if user does not have access", %{conn: conn, project: project} do
    user = Map.put(User.changeset(%User{}, %{}), :id, 1)
    conn = guardian_login(conn, user)

    conn = post conn, note_path(conn, :create, project), @valid_attrs
    assert response(conn, 401)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, project: project} do
    conn = post conn, note_path(conn, :create, project), @invalid_attrs
    assert response(conn, 400)
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, project: project} do
    note = Repo.insert! Note.changeset(%Note{project_id: project.id}, @valid_attrs)
    conn = put conn, note_path(conn, :update, project, note), @valid_attrs
    assert json_response(conn, 200)["id"]
    assert Repo.get_by(Note, %{text: Map.get(@valid_attrs, :text)})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, project: project} do
    note = Repo.insert! Note.changeset(%Note{project_id: project.id}, @valid_attrs)
    conn = put conn, note_path(conn, :update, project, note), @invalid_attrs
    assert response(conn, 400)
  end

  test "deletes chosen resource", %{conn: conn, project: project} do
    note = Repo.insert! Note.changeset(%Note{project_id: project.id}, @valid_attrs)
    conn = delete conn, note_path(conn, :delete, project, note)
    assert response(conn, 204)
    refute Repo.get(Note, note.id)
  end
end
