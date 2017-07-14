defmodule BetterNotes.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :auth_provider, :string
      add :first_name, :string
      add :last_name, :string
      add :avatar, :string

      timestamps()
    end

    # Unique email address constraint, via DB index
    create index(:users, [:email], unique: true)
  end
end
