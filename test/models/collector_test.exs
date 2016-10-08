defmodule DevicePresence.CollectorTest do
  use DevicePresence.ModelCase

  alias DevicePresence.Collector

  @valid_attrs %{location: "some content", name: "some content", ip: "192.168.1.3"}
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
