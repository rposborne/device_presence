defmodule DevicePresence.EventTest do
  use DevicePresence.ModelCase
  doctest DevicePresence.Event
  alias DevicePresence.Event

  @valid_attrs %{collector_id: 1, event_type: "offline", started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  setup do
    {:ok, %{date: Timex.to_datetime({{2010, 4, 17}, {15, 0, 0}}, "America/Chicago") }}
  end

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "duration of day when ended_at is nil", %{date: date} do
    minutes = DevicePresence.Event.duration_of_day(
      date,
      %Event{
        started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010} # These are UTC
      }
    )
    assert minutes == 899
  end

  test "duration of day when started_at was the previous day", %{date: date} do
    minutes = DevicePresence.Event.duration_of_day(
      date,
      %Event{
        started_at: %{day: 16, hour: 14, min: 0, month: 4, sec: 0, year: 2010}
      }
    )
    assert minutes == 1439
  end

  test "duration of day when ended_at was the next day", %{date: date} do
    minutes = DevicePresence.Event.duration_of_day(
      date,
      %Event{
        started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010},
        ended_at: %{day: 18, hour: 14, min: 0, month: 4, sec: 0, year: 2010}
      }
    )
    assert minutes == 899
  end
end
