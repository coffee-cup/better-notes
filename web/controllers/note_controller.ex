defmodule BetterNotes.NoteController do
  use BetterNotes.Web, :controller

  alias BetterNotes.ErrorView
  alias BetterNotes.Note
  alias BetterNotes.Project

  plug :project_id_int
  plug :has_access

  def index(conn, %{"project_id" => project_id}) do
    notes =
      from(n in Note, where: n.project_id == ^project_id, order_by: [asc: :inserted_at])
      |> Repo.all()
    render(conn, "index.json", notes: notes)
  end

  def create(conn, %{"text" => _, "project_id" => project_id} = note_params) do
    changeset = Note.changeset(%Note{project_id: project_id}, note_params)

    case Repo.insert(changeset) do
      {:ok, note} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", note_path(conn, :show, note.project_id, note))
        |> render("show.json", note: note)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BetterNotes.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def create(conn, _) do
    conn |> put_status(400) |> render(ErrorView, "400.json")
  end

  def show(conn, %{"id" => id, "project_id" => project_id}) do
    case Repo.get_by(Note, id: id, project_id: project_id) do
      %Note{} = note ->
        render(conn, "show.json", note: note)
      _ ->
        conn |> put_status(404) |> render(ErrorView, "404.json")
    end
  end
  def show(conn, _) do
    conn |> put_status(400) |> render(ErrorView, "400.json")
  end

  def update(conn, %{"id" => id, "text" => _, "project_id" => project_id} = note_params) do
    case Repo.get_by(Note, id: id, project_id: project_id) do
      %Note{} = note ->
        changeset = Note.changeset(note, note_params)
        case Repo.update(changeset) do
          {:ok, note} ->
            render(conn, "show.json", note: note)
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

  def delete(conn, %{"id" => id, "project_id" => project_id}) do
    case Repo.get_by(Note, id: id, project_id: project_id) do
      %Note{} = note ->
        Repo.delete!(note)
        send_resp(conn, :no_content, "")
      _ ->
        conn |> put_status(404) |> render(ErrorView, "404.json")
    end
  end
  def delete(conn, _) do
    conn |> put_status(400) |> render(ErrorView, "400.json")
  end

  # Try to convert a `project_id` in the params to an integer
  # If it fails, halt request and render a bad request error
  defp project_id_int(%{:params => %{"project_id" => project_id}} = conn, _) do
    case Integer.parse(project_id) do
      {i, ""} ->
        params = Map.put(conn.params, "project_id", i)
        Map.put(conn, :params, params)
      _ ->
        conn |> put_status(400) |> render(ErrorView, "400.json") |> halt
    end
  end
  defp project_id_int(conn, _), do: conn

  # Does the user have access to the project with `id`
  defp has_access(%{:params => %{"project_id" => project_id}} = conn, _) do
    case Repo.get_by(Project, id: project_id, user_id: conn.assigns.user_id) do
      %Project{} -> conn
      _ -> conn |> put_status(401) |> render(ErrorView, "401.json") |> halt
    end
  end
  defp has_access(conn, _), do: conn
end
