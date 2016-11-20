defmodule DevicePresence.ScanController do
  use DevicePresence.Web, :controller

  alias DevicePresence.Collector
  alias DevicePresence.Event
  def create(conn, params) do

    collector = Repo.get!(DevicePresence.Collector, params["collector_id"])

    case collector.type do
      "device_presence" -> handle_device_presence(collector, params["devices"])
      true -> :ok
    end
    
    conn
    |> send_resp(202, "")
  end

  def handle_device_presence(collector, devices) do
    Enum.each(devices, fn(e) -> DevicePresence.PersistDeviceScan.persist_device(collector.id, e) end)

    assoc(collector, :devices)
      |> Repo.all
      |> Enum.each(fn(d) -> DevicePresence.PersistDeviceScan.update_status(d, devices) end)
  end
end
