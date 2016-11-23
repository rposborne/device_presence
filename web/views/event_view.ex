defmodule DevicePresence.EventView do
  use DevicePresence.Web, :view
  alias DevicePresence.Event

  def render("index.json", %{events: events, for_date: date}) do
    %{data: render_many(events, DevicePresence.EventView, "event.json", for_date: date)}
  end

  def render("index.json", %{events: events}) do
    %{data: render_many(events, DevicePresence.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, DevicePresence.EventView, "event.json")}
  end

  def render("event.json", %{event: event, for_date: date}) do
    timezone = Timex.Timezone.get(date.time_zone)

    %{
      id: event.id,
      event_type: event.event_type,
      started_at: Timex.Timezone.convert(event.started_at, timezone),
      ended_at: Timex.Timezone.convert(event.ended_at || Timex.now, timezone),
      duration_in_minutes: Event.duration_of_day(date, event)
    }
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      event_type: event.event_type,
      started_at: event.started_at,
      ended_at: event.ended_at || Timex.now
    }
  end
end
