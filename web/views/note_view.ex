defmodule BetterNotes.NoteView do
  use BetterNotes.Web, :view

  def render("index.json", %{notes: notes}) do
    render_many(notes, BetterNotes.NoteView, "note.json")
  end

  def render("show.json", %{note: note}) do
    render_one(note, BetterNotes.NoteView, "note.json")
  end

  def render("note.json", %{note: note}) do
    %{id: note.id,
      project_id: note.project_id,
      text: note.text,
      html: note.html}
  end
end
