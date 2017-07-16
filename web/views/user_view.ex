defmodule BetterNotes.UserView do
  use BetterNotes.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, BetterNotes.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, BetterNotes.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      auth_provider: user.auth_provider,
      first_name: user.first_name,
      last_name: user.last_name,
      avatar: user.avatar}
  end
end
