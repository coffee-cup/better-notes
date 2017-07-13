defmodule BetterNotes.ElmController do
  use BetterNotes.Web, :controller

  def index(conn, _params) do
    conn
    |> render(BetterNotes.ElmView, "index.html")
  end
end
