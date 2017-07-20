defmodule BetterNotes.ErrorViewTest do
  use BetterNotes.ConnCase, async: true

  import Phoenix.View

  test "renders 404.json" do
    assert render(BetterNotes.ErrorView, "404.json", []) ==
      %{title: "Resource not found", code: 404}
  end

  test "render 500.json" do
    assert render(BetterNotes.ErrorView, "500.json", []) ==
      %{title: "Internal Server Error", code: 500}
  end

  test "render any other" do
    assert render(BetterNotes.ErrorView, "505.json", []) ==
      %{title: "Internal Server Error", code: 500}
  end
end
