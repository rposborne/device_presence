defmodule DevicePresence.PersistSession do
  require DevicePresence.Repo
  require DevicePresence.Device

  def persist_nodes(nodes) do
    IO.puts "________________Nodes_________________"
    Enum.each(nodes, fn(e) -> persist_node(e) end)
  end

  def persist_events(events) do
    IO.puts "________________Events_________________"
    Enum.each(events, fn(e) -> persist_event(e) end)
  end

  def persist_event(event) do
    IO.inspect event
    node = DevicePresence.Repo.one(DevicePresence.Device, fing_node: event[:node])
    prev_node = DevicePresence.Repo.one(DevicePresence.Device, fing_node: event[:prev_node])
    # id, node, prevtime, time, type
    #
    %DevicePresence.Event{
      event_type: event[:type],
      node_id: node[:id],
      prev_node_id: prev_node[:id],
      occured_at: event[:time]
    } |> Repo.insert!
  end

  def persist_node(node) do
    IO.inspect node
    # hwAddress, id, inetAddress

    changeset = %DevicePresence.Device{
      mac_address: node[:hwAddress],
      fing_node: node[:id],
      last_seen_ip: node[:inetAddress],
      last_seen_at: Ecto.DateTime.from_erl(:calendar.universal_time())
     }  |> DevicePresence.Repo.insert!
  end
end
