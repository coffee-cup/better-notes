defmodule BetterNotes.UserController do
  use BetterNotes.Web, :controller

  alias BetterNotes.User

    plug Guardian.Plug.EnsureAuthenticated, handler: BetterNotes.AuthController

    def index(conn, _params) do
      users = Repo.all(User)
      render(conn, "index.json-api", data: users)
    end

    def current(conn, _params) do
      user = conn
      |> Guardian.Plug.current_resource

      conn
      |> render(BetterNotes.UserView, "show.json-api", data: user)
    end
end
