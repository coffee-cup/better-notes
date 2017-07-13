defmodule BetterNotes.ApiController do
  use BetterNotes.Web, :controller

  def index(conn, _params) do
    data = %{hello: "world"}

    render conn, "index.json", data: data
  end
end
