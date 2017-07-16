defmodule BetterNotes.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use BetterNotes.Web, :controller

  plug Ueberauth
  plug :scrub_params, "user" when action in [:sign_in_user]

  alias Ueberauth.Strategy.Helpers
  alias BetterNotes.ErrorView
  alias BetterNotes.User

  def request(_conn, _params) do
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    render(ErrorView, "401.json")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect auth
    case AuthUser.find_or_create(auth) do
      {:ok, user} ->
        sign_in_user(conn, %{"user" => user})
      {:error, reason} ->
        IO.inspect reason
        conn
        |> render(ErrorView, "401.json")
    end
  end

  def sign_in_user(conn, %{"user" => user}) do
    # Attemp to retrieve exactly one user from the DB,
    # whose email matches the one provided with the login request
    case Repo.get_by(User, email: user.email) do
      %User{} = user ->
        {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

        auth_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(auth_conn)
        {:ok, claims} = Guardian.Plug.claims(auth_conn)

        IO.puts "\n\n\n----"
        IO.inspect Guardian.Plug.current_resource(auth_conn)

        IO.inspect jwt

        auth_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> json(%{access_token: jwt}) # Return token to client
      nil ->
        sign_up_user(conn, %{"user" => user})
    end
  end

  def sign_up_user(conn, %{"user" => user}) do
    changeset = User.changeset %User{}, %{
      email: user.email,
      avatar: user.avatar,
      first_name: user.first_name,
      last_name: user.last_name,
      auth_provider: "google"
    }

    case Repo.insert changeset do
      {:ok, user} ->
        {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> json(%{access_token: jwt})
      {:error, _} ->
        conn
        |> put_status(422)
        |> render(ErroView, "422.json")
    end
  end

  def unauthenticated(conn, params) do
    IO.inspect params
    IO.inspect conn

    conn
    |> put_status(401)
    |> render(ErrorView, "401.json")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> render(ErrorView, "403.json")
  end

  def already_authenticated(conn, _params) do
    conn
    |> put_status(200)
    |> render(ErrorView, "200.json")
  end

  def no_resource(conn, _params) do
    conn
    |> put_status(404)
    |> render(ErrorView, "404.json")
  end

end
