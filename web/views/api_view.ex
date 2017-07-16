defmodule BetterNotes.ApiView do
  use BetterNotes.Web, :view

  def render("index.json", %{data: data}) do
    data
  end

  def render("auth.json", %{user: user}) do
    user
  end
end
