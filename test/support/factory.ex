defmodule DevicePresence.Factory do
  use ExMachina.Ecto, repo: DevicePresence.Repo

  alias DevicePresence.User
  alias DevicePresence.Device
  alias DevicePresence.Location
  alias DevicePresence.Event

  def user_factory do
    %User{
      name: "Bob Belcher",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def location_factory do
    %Location{
      name: "Washington DC"
    }
  end

  def device_factory do
    %Device{
      collector_id: 1,
      mac_address: "b8:e8:56:2e:06:a0"
    }
  end

  def event_factory do
    %Event{
      event_type: "online",
      started_at:  %{day: 17, hour: 19, min: 0, month: 4, sec: 0, year: 2016},
      ended_at:  %{day: 17, hour: 19, min: 5, month: 4, sec: 0, year: 2016},
      collector_id: 1
    }
  end

  def with_events(user, opts \\ []) do
    opts = opts ++ [user: user]
    insert(:event, opts)
  end
end
