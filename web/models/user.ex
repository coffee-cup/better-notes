defmodule BetterNotes.User do
  use BetterNotes.Web, :model

  schema "users" do
    field :email, :string
    field :auth_provider, :string
    field :first_name, :string
    field :last_name, :string
    field :avatar, :string

    has_many :projects, BetterNotes.Project
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :auth_provider, :first_name, :last_name, :avatar])
    |> validate_required([:email, :auth_provider, :first_name, :last_name, :avatar])
    |> unique_constraint(:email)
  end
end
