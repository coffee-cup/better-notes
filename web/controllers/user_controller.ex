defmodule BetterNotes.UserController do
  use BetterNotes.Web, :controller

  alias BetterNotes.User

  def show(conn, %{"id" => id} = params) do
    IO.inspect params
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def create(conn, params) do
    IO.inspect params
    changeset = User.changeset(%User{}, params)
    user = Repo.insert!(changeset)

    IO.inspect user

    render(conn, "show.json", user: user)
  end
end
