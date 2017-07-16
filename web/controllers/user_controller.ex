defmodule BetterNotes.UserController do
  use BetterNotes.Web, :controller

  alias BetterNotes.User

  plug Guardian.Plug.EnsureAuthenticated, handler: BetterNotes.AuthController

  def index(conn, _params) do
    users = Repo.all(User)
    IO.puts "\n\n\n\n\n-----"
    IO.inspect users
    render(conn, "index.json", users: users)
  end

  def show(conn, _params) do
    user = conn
    |> Guardian.Plug.current_resource

    conn
    |> render("show.json", user: user)
  end
end
