defmodule BetterNotes.ProjectView do
  use BetterNotes.Web, :view

  def render("index.json", %{projects: projects}) do
    render_many(projects, BetterNotes.ProjectView, "project.json")
  end

  def render("show.json", %{project: project}) do
    render_one(project, BetterNotes.ProjectView, "project.json")
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      name: project.name,
      user_id: project.user_id}
  end
end
