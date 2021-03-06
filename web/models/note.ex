defmodule BetterNotes.Note do
  use BetterNotes.Web, :model

  alias BetterNotes.Parser.Markdown

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
    |> foreign_key_constraint(:project_id)
    |> put_change(:html, Markdown.to_html(get_text(params)))
    |> validate_required([:text, :html])
  end

  defp get_text(%{text: text}), do: text
  defp get_text(%{"text" => text}), do: text
  defp get_text(%{}), do: nil
end
