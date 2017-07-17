defmodule BetterNotes.UserPlug do

  import Plug.Conn

  def load_user(conn, _) do
    user = conn |> Guardian.Plug.current_resource
    conn
    |> assign(:user, user)
    |> assign(:user_id, user.id)
  end

end
