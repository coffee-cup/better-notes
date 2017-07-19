defmodule BetterNotes.NoteControllerTest do
  use BetterNotes.ConnCase

  alias BetterNotes.Note
  @valid_attrs %{html: "some content", text: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, note_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = get conn, note_path(conn, :show, note)
    assert json_response(conn, 200) == %{"id" => note.id,
      "project_id" => note.project_id,
      "text" => note.text,
      "html" => note.html}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, note_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, note_path(conn, :create), note: @valid_attrs
    assert json_response(conn, 201)["id"]
    assert Repo.get_by(Note, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, note_path(conn, :create), note: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = put conn, note_path(conn, :update, note), note: @valid_attrs
    assert json_response(conn, 200)["id"]
    assert Repo.get_by(Note, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = put conn, note_path(conn, :update, note), note: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = delete conn, note_path(conn, :delete, note)
    assert response(conn, 204)
    refute Repo.get(Note, note.id)
  end
end
