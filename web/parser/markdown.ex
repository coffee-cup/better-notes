defmodule BetterNotes.Parser.Markdown do

  @doc """
  Converts markdown text to an html string
  """
  def to_html(text) do
    case Earmark.as_html(text) do
      {:ok, html_doc, _} -> html_doc
      {:error, _, _} -> ""
    end
  end

end
