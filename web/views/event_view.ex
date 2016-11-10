defmodule DevicePresence.EventView do
  use DevicePresence.Web, :view
  alias DevicePresence.Event

  def render("index.json", %{events: events}) do
    %{data: render_many(events, DevicePresence.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, DevicePresence.EventView, "event.json")}
  end
  # TODO: This should accept a timezone to render the dates respective too.
  def render("event.json", %{event: event}) do
    timezone = Timex.Timezone.get("America/New_York", Timex.now)

    %{
      id: event.id,
      event_type: event.event_type,
      started_at: Timex.Timezone.convert(event.started_at, timezone),
      ended_at: Timex.Timezone.convert(event.ended_at || Timex.now, timezone),
      duration_in_minutes: Event.duration_of_day(event, timezone)
    }
  end
end
