defmodule DevicePresence.ScanController do
  use DevicePresence.Web, :controller

  alias DevicePresence.Collector
  alias DevicePresence.Event
  def create(conn, params) do

    if params["collector_id"] do
        collector = Repo.get!(DevicePresence.Collector, params["collector_id"])
    else
      collector = conn.assigns.collector
    end


    case collector.type do
      "device_presence" -> handle_device_presence(collector, params["devices"])
      "slack_presence" -> handle_slack_presence(collector, params["user"])
      true -> :ok
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

  def handle_slack_presence(collector, user_params) do
    DevicePresence.SlackPresenceHandler.persist_user(user_params)
  end
end
