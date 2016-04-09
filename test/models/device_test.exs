defmodule DevicePresence.DeviceTest do
  use DevicePresence.ModelCase

  alias DevicePresence.Device

  @valid_attrs %{last_seen_at: "2010-04-17 14:00:00", mac_address: "some content", name: "some content", user_id: 42}
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
