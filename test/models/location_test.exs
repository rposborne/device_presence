defmodule DevicePresence.LocationTest do
  use DevicePresence.ModelCase

  alias DevicePresence.Location

  @valid_attrs %{address_1: "some content", address_2: "some content", city: "some content", country: "some content", name: "some content", postal_code: "some content", state: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end
end
