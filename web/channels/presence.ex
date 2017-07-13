defmodule BetterNotes.Presence do
    use Phoenix.Presence, otp_app: :presence_chat,
                        pubsub_server: BetterNotes.PubSub
end
