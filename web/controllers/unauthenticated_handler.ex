defmodule DevicePresence.UnauthenticatedHandler do
  import Plug.Conn
  alias DevicePresence.Collector
  alias DevicePresence.Repo

  def unauthenticated(conn, params) do
    conn
    |> send_resp(401, "go away")
    |> halt()
  end
end
