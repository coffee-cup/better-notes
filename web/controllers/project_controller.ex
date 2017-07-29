defmodule BetterNotes.ProjectController do
  use BetterNotes.Web, :controller

  alias BetterNotes.ErrorView
  alias BetterNotes.Project

  def index(conn, _params) do
    projects =
      from(p in Project, where: p.user_id == ^conn.assigns.user_id, order_by: [asc: :inserted_at])
      |> Repo.all()
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"name" => _} = project_params) do
    changeset = Project.changeset(%Project{user_id: conn.assigns.user_id}, project_params)

    case Repo.insert(changeset) do
      {:ok, project} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", project_path(conn, :show, project))
        |> render("show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_status(201)
        |> render(BetterNotes.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def create(conn, _) do
    conn |> put_status(400) |> render(ErrorView, "400.json")
  end

  def show(conn, %{"id" => id}) do
    case Repo.get_by(Project, id: id, user_id: conn.assigns.user_id) do
      %Project{} = project ->
        render(conn, "show.json", project: project)
      _ ->
        conn |> put_status(404) |> render(ErrorView, "404.json")
    end
  end
  def show(conn, _) do
    conn |> put_status(400) |> render(ErrorView, "400.json")
  end

  def update(conn, %{"id" => id, "name" => _} = project_params) do
    case Repo.get_by(Project, id: id, user_id: conn.assigns.user_id) do
      %Project{} = project ->
        changeset = Project.changeset(project, project_params)
        case Repo.update(changeset) do
          {:ok, project} ->
            render(conn, "show.json", project: project)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(BetterNotes.ChangesetView, "error.json", changeset: changeset)
        end
      _ ->
        conn |> put_status(404) |> render(ErrorView, "404.json")
    end
  end
  def update(conn, _) do
    conn |> put_status(400) |> render(ErrorView, "400.json")
  end

  def delete(conn, %{"id" => id}) do
    case Repo.get_by(Project, id: id, user_id: conn.assigns.user_id) do
      %Project{} = project ->
        Repo.delete!(project)
        conn |> put_status(204) |> send_resp(:no_content, "")
      _ ->
        conn |> put_status(404) |> render(ErrorView, "404.json")
    end
  end
  def delete(conn, _) do
    conn |> put_status(400) |> render(ErrorView, "400.json")
  end
end
