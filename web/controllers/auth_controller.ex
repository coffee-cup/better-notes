defmodule BetterNotes.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use BetterNotes.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias BetterNotes.ErrorView

  def request(_conn, _params) do
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    render(ErrorView, "401.json")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect auth
    case AuthUser.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> render(BetterNotes.ApiView, "auth.json", user: user)
      {:error, reason} ->
        IO.inspect reason
        conn
        |> render(ErrorView, "401.json")
    end
  end

end
