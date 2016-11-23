defmodule DevicePresence.DeviceTest do
  use DevicePresence.ModelCase

  alias DevicePresence.Device

  @valid_attrs %{last_seen_at: %{day: 17, hour: 19, min: 0, month: 4, sec: 0, year: 2016}, mac_address: "some content", name: "some content", collector_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Device.changeset(%Device{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Device.changeset(%Device{}, @invalid_attrs)
    refute changeset.valid?
  end
end
