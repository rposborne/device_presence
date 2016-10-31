defmodule DevicePresence.EventTest do
  use DevicePresence.ModelCase

  alias DevicePresence.Event

  @valid_attrs %{node_id: 42, occured_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end



# started_at: "2016-10-25T17:50:36.12745-04:00",
# id: 10540,
# event_type: "offline",
# ended_at: "2016-10-26T08:34:27.024283-04:00",
# duration_in_minutes: 514
