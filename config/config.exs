# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :better_notes,
  ecto_repos: [BetterNotes.Repo]

# Configures the endpoint
config :better_notes, BetterNotes.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kcGu5y6FyvtAd/THNFAbOrYYvi/iWVNQnJyXuSxc9vUWMFy0+E7Z1kfRSYJKgt/Q",
  render_errors: [view: BetterNotes.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BetterNotes.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  base_path: "/api/v1/auth",
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]},
    identity: {Ueberauth.Strategy.Identity, [
      callback_methods: ["POST"],
      uid_field: :username,
      nickname_field: :username
    ]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Guardian configuration
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "BetterNotes",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_SECRET") || "rFtDNsugNi8jNJLOfvcN4jVyS/V7Sh+9pBtc/J30W8h4MYTcbiLYf/8CEVfdgU6/",
  serializer: BetterNotes.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
