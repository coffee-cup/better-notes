defmodule BetterNotes.ApiView do
  use BetterNotes.Web, :view

  def render("index.json", %{data: data}) do
    data
  end
end
