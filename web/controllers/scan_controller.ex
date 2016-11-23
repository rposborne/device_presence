defmodule DevicePresence.ScanController do
  use DevicePresence.Web, :controller

  def create(conn, params) do
    collector =
      case params["collector_id"] do
        nil -> conn.assigns.collector
        _ -> Repo.get!(DevicePresence.Collector, params["collector_id"])
      end

    case collector.type do
      "device_presence" -> handle_device_presence(collector, params["devices"])
      "slack_presence" -> handle_slack_presence(collector, params)
    end

    conn
    |> send_resp(202, "")
  end


  def handle_device_presence(collector, devices) do
    Enum.each(devices, fn(e) -> DevicePresence.DevicePresenceHandler.persist_device(collector.id, e) end)

    assoc(collector, :devices)
      |> Repo.all
      |> Enum.each(fn(d) -> DevicePresence.DevicePresenceHandler.update_status(d, devices) end)
  end

  def handle_slack_presence(collector, event_params) do
    DevicePresence.SlackPresenceHandler.persist_user(event_params["user"])
    DevicePresence.SlackPresenceHandler.update_status(collector, event_params)
  end
end
