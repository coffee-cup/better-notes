defmodule BetterNotes.Repo.Migrations.CreateNote do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :text, :string
      add :html, :string
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:notes, [:project_id])
  end
end
