defmodule DevicePresence.NodeController do
  use DevicePresence.Web, :controller

  def index(conn, _params) do
    IO.puts inspect(fetch_nodes)
    render(conn, "index.json", nodes: fetch_nodes)
  end

  defp fetch_nodes do
    DevicePresence.ScanSession.fetch_session
  end
end
