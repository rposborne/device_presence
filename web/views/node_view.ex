defmodule DevicePresence.NodeView do
  use DevicePresence.Web, :view

  def render("index.json", %{nodes: nodes}) do
    %{data: render_many(nodes, DevicePresence.NodeView, "node.json")}
  end

  def render("show.json", %{node: node}) do
    %{data: render_one(node, DevicePresence.NodeView, "node.json")}
  end

  def render("node.json", %{node: node}) do
    %{id: node.id,
      node: node.node,
      previous_seen_at: node.prevtime,
      seen_at: node.time,
      status: node.type}
  end
end
