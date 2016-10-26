defmodule DevicePresence.DeviceApiController do
  use DevicePresence.Web, :controller

  alias DevicePresence.Device

  def index(conn, %{"user_id" => user_id}) do
    devices = Device.for_user(user_id)
    |> Device.with_events
    |> Repo.all
    render(conn, "index.json", devices: devices)
  end

  # def for_date(conn, %{"user_id" => user_id, "for_date" => date}) do
  #   events = Device.for_user(user_id)
  #   |> Device.for_day(date)
  #   |> Repo.all
  #   render(conn, "index.json", events: events)
  # end
end
