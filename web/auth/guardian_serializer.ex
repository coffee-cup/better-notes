defmodule BetterNotes.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias BetterNotes.Repo
  alias BetterNotes.User

  def for_token(%User{} = user) do
    {:ok, "User:#{user.id}"}
  end
  def for_token(_) do
    {:error, "Unknown resource type"}
  end

  def from_token("User:" <> id) do
    IO.puts "\n\n\n\n--------"
    IO.inspect id
    {:ok, Repo.get(User, id)}
  end
  def from_token(_) do
    {:error, "Unknown resource type"}
  end
end
