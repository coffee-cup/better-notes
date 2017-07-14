defmodule BetterNotes.UserView do
  use BetterNotes.Web, :view
  use JaSerializer.PhoenixView

  attributes [:avatar, :email, :first_name, :last_name, :auth_provider]
end
