defmodule DevicePresence.UnauthenticatedHandler do
  import Plug.Conn

  def unauthenticated(conn, _params) do
    conn
    |> send_resp(401, "go away")
    |> halt()
  end
end
