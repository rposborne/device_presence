defmodule DevicePresence.PersistSession do
  require DevicePresence.Repo
  require DevicePresence.Device

  def persist_nodes(events) do
    Enum.each(events, fn(x) -> DevicePresence.Repo.insert! %DevicePresence.Device{mac_address: x[:node]} end)
  end

  def persist_events(nodes) do
    Enum.each(nodes, fn(x) -> DevicePresence.Repo.insert! %DevicePresence.Device{mac_address: x[:node]} end)
  end

  def persist_event(event) do
    Repo.insert! %DevicePresence.Device{mac_address: event[:node]}
  end
end
