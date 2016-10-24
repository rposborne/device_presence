defmodule DevicePresence.ScanController do
  use DevicePresence.Web, :controller
  alias DevicePresence.Device
  alias DevicePresence.Collector
  alias DevicePresence.Event
  def create(conn, params) do
    Enum.each(params["devices"], fn(e) -> persist_device(params["collector_id"], e) end)

    collector = Repo.get!(Collector, params["collector_id"])
    devices = Repo.all assoc(collector, :devices)
    Enum.each(devices, fn(d) -> update_status(d, params["devices"]) end)

    # For a collector, go through devices, see who is reporting.
    # If expect online, and in payload, do nothing.
    # If state change has occured record an event
    conn
    |> send_resp(202, "")
  end

  defp update_status(device, reporting_devices) do
    online_device = Enum.find(reporting_devices, fn(d) -> d["mac_address"] == device.mac_address end)

    cond do
      online_device && (device.status == "offline" || device.status == nil || device.status == "") ->
        store_status(device, "online")
      online_device && device.status == "online" ->
        IO.puts "#{device.mac_address} still online"
      device.status == "online" || (device.status == nil || device.status == "") ->
        store_status(device, "offline")
      device.status == "offline" ->
        IO.puts "#{device.mac_address} still offline"
    end
  end

  defp store_status(device, status) do
    store_event(device, status)
    Device.changeset(device, %{status: status}) |> Repo.update
  end

# This is params not a device object(< what's the right turn for this)
  defp find_or_build(device) do
    query = from u in Device,
            where: u.mac_address == ^device["mac_address"]

    existing_device = Repo.one(query)
    if !existing_device  do
      Device.changeset(%Device{status: "online"}, device)
    else
      Device.changeset(existing_device, device)
    end
  end

  defp persist_device(collector_id, device_params) do
    params = Map.merge(device_params, %{
      "collector_id" => collector_id
    })

    find_or_build(params) |> Repo.insert_or_update
  end

  def store_event(device, type) do
    event_time = DateTime.utc_now
    update_prev_event(device, event_time)

    Event.changeset(%Event{}, %{collector_id: device.collector_id, device_id: device.id, event_type: type, started_at: event_time}) |> Repo.insert!
  end

  def update_prev_event(device, time) do
    event = Device.most_recent_event(device) |> Repo.one!
    Event.changeset(event, %{ended_at: time}) |> Repo.update! |> IO.inspect
  end
end