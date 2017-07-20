defmodule BetterNotes.UserControllerTest do
  use BetterNotes.ConnCase

  alias BetterNotes.User

  @valid_attrs %{
    auth_provider: "some content",
    avatar: "some content",
    email: "some content",
    first_name: "some content",
    last_name: "some content"
  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = guardian_login(conn, user)
    conn = get conn, user_path(conn, :show)
    assert json_response(conn, 200) == %{"id" => user.id,
      "email" => user.email,
      "auth_provider" => user.auth_provider,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "avatar" => user.avatar}
  end

  test "unauthorized error when user is not logged in", %{conn: conn} do
    conn = get conn, user_path(conn, :show)
    assert conn.status == 401
  end

  test "unauthorized error when user has not been created", %{conn: conn} do
    user = Map.put(User.changeset(%User{}, @valid_attrs), :id, 1)
    conn = guardian_login(conn, user)
    conn = get conn, user_path(conn, :show)
    assert conn.status == 401
  end
end
