defmodule DevicePresence.CollectorScanTest do
  use DevicePresence.ModelCase

  alias DevicePresence.CollectorScan

  @valid_attrs %{occurred_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CollectorScan.changeset(%CollectorScan{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CollectorScan.changeset(%CollectorScan{}, @invalid_attrs)
    refute changeset.valid?
  end
end
