defmodule DevicePresence.EventController do
  use DevicePresence.Web, :controller

  alias DevicePresence.Event

  def index(conn, %{"device_api_id" => device_id}) do
    events = Event.for_device(device_id)
    |> Repo.all
    render(conn, "index.json", events: events)
  end

  def for_date(conn, %{"device_api_id" => device_id, "for_date" => date}) do
    events = Event.for_device(device_id)
    |> Event.for_day(date)
    |> Repo.all
    render(conn, "index.json", events: events)
  end
end
