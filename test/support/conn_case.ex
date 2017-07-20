defmodule BetterNotes.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias BetterNotes.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import BetterNotes.Router.Helpers

      # The default endpoint for testing
      @endpoint BetterNotes.Endpoint

      # Sign in the user and place the `jwt` token in the headers
      def guardian_login(%BetterNotes.User{} = user), do: guardian_login(conn(), user, :token, [])
      def guardian_login(%BetterNotes.User{} = user, token), do: guardian_login(conn(), user, token, [])
      def guardian_login(%BetterNotes.User{} = user, token, opts), do: guardian_login(conn(), user, token, opts)

      def guardian_login(%Plug.Conn{} = conn, user), do: guardian_login(conn, user, :token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token), do: guardian_login(conn, user, token, [])
      def guardian_login(%Plug.Conn{} = conn, user, token, opts) do
        auth_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(auth_conn)

        auth_conn
        |> assign(:user, user)
        |> assign(:user_id, user.id)
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("accept", "application/json")
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BetterNotes.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(BetterNotes.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
