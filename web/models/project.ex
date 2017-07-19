defmodule BetterNotes.Project do
  use BetterNotes.Web, :model

  schema "projects" do
    field :name, :string
    belongs_to :user, BetterNotes.User

    has_many :notes, BetterNotes.Note
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
