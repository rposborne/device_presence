defmodule DevicePresence.PersistSession do
  require DevicePresence.Repo
  require DevicePresence.Device
  import Ecto.Query, only: [from: 2]

  def persist_devices(nodes) do
    IO.puts "________________Nodes_________________"
    Enum.each(nodes, fn(e) -> persist_device(e) end)
  end

  def persist_events(events) do
    IO.puts "________________Events_________________"
    Enum.each(events, fn(e) -> persist_event(e) end)
  end

  def get_device_for_event(event) do
    query = from d in DevicePresence.Device,
      where: d.fing_node == ^event[:node],
      limit: 1

    DevicePresence.Repo.one(query)
  end

  def get_prev_device_for_event(event) do
    if event[:prev_node] do
      query = from d in DevicePresence.Device,
        where: d.fing_node == ^event[:prev_node],
        limit: 1

      DevicePresence.Repo.one(query)
    end
  end

  def persist_event(event) do
    device = event |> get_device_for_event
    prev_device = event |> get_prev_device_for_event
    {:ok, occured_at} =  Ecto.DateTime.cast(event[:time])
    # id, node, prevtime, time, type
    #
    %DevicePresence.Event{
      event_type: event[:type],
      node_id: device.id,
      prev_node_id: prev_device[:id],
      occured_at: occured_at
    } |> DevicePresence.Repo.insert!
  end

  def persist_device(device) do
    IO.inspect device
    %DevicePresence.Device{
      mac_address: device[:hwAddress],
      fing_node: device[:id],
      last_seen_ip: device[:inetAddress],
      last_seen_at: Ecto.DateTime.from_erl(:calendar.universal_time())
     }  |> DevicePresence.Repo.insert!
  end
end
