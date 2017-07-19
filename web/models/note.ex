defmodule BetterNotes.Note do
  use BetterNotes.Web, :model

  schema "notes" do
    field :text, :string
    field :html, :string
    belongs_to :project, BetterNotes.Project

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :html])
    |> validate_required([:text])
    |> foreign_key_constraint(:project_id)
  end
end
