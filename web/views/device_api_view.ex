
defmodule DevicePresence.DeviceApiView do
  use DevicePresence.Web, :view

  def render("index.json", %{devices: devices}) do
    %{data: render_many(devices, DevicePresence.DeviceApiView, "device.json")}
  end

  def render("show.json", %{device: device}) do
    %{data: render_one(device, DevicePresence.DeviceApiView, "device.json")}
  end

  def render("device.json", %{device_api: device}) do
    %{
      id: device.id,
      name: device.name,
      last_seen_at: device.last_seen_at
      # events: render_many(device.events, DevicePresence.EventView, "event.json")
    }
  end

end
