defmodule BetterNotes.UserView do
  use BetterNotes.Web, :view
  # use JaSerializer.PhoenixView

  # attributes [:email]

  def render("show.json", %{user: %{email: email}}) do
    %{email: email}
  end

  def render("create.json", %{user: %{email: email}}) do
    %{email: email}
  end
end
