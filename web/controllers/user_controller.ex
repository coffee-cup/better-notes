defmodule BetterNotes.UserController do
  use BetterNotes.Web, :controller

  alias BetterNotes.User

  def show(conn, _params) do
    user = conn
    |> Guardian.Plug.current_resource

    IO.puts "\n\n\n----"
    IO.inspect user

    conn
    |> render("show.json", user: user)
  end
end
