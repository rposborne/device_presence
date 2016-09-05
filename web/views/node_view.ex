defmodule DevicePresence.NodeView do
  use DevicePresence.Web, :view

  def render("index.json", %{nodes: devicess}) do
    %{data: render_many(devicess, DevicePresence.NodeView, "node.json")}
  end

  def render("show.json", %{node: device}) do
    %{data: render_one(device, DevicePresence.NodeView, "node.json")}
  end

  def render("node.json", %{node: device}) do
    %{id: device.id,
      node: device.node,
      previous_seen_at: device.prevtime,
      seen_at: device.time,
      status: device.type}
  end
end
