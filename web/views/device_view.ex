defmodule DevicePresence.DeviceView do
  use DevicePresence.Web, :view

  def render("index.json", %{devices: devices}) do
    %{data: render_many(devices, DevicePresence.DeviceView, "device.json")}
  end

  def render("show.json", %{device: device}) do
    %{data: render_one(device, DevicePresence.DeviceView, "device.json")}
  end

  def render("device.json", %{device: device}) do
    %{id: device.id,
      name: device.name,
      mac_address: device.mac_address,
      last_seen_at: device.last_seen_at,
      user_id: device.user_id}
  end
end
