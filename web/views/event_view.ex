defmodule DevicePresence.EventView do
  use DevicePresence.Web, :view
  alias DevicePresence.Event

  def render("index.json", %{events: events}) do
    %{data: render_many(events, DevicePresence.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, DevicePresence.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      event_type: event.event_type,
      started_at: event.started_at,
      ended_at: event.ended_at,
      duration: Event.duration(event)
    }
  end
end
