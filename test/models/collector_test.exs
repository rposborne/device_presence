defmodule DevicePresence.CollectorTest do
  use DevicePresence.ModelCase

  alias DevicePresence.Collector

  @valid_attrs %{location_id: 1, name: "some content", type: "slack_presence"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Collector.changeset(%Collector{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Collector.changeset(%Collector{}, @invalid_attrs)
    refute changeset.valid?
  end
end
