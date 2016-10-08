defmodule DevicePresencePersistSessionTest do
  use DevicePresence.ModelCase

  test "will produce a list of devices" do
    file = File.read!(Path.expand("test/fixtures/session.txt"))
    devices = DevicePresence.FetchFingSession.devices(file)


    inital_count = List.first Repo.all(from d in DevicePresence.Device, select: count(d.id))
    DevicePresence.PersistSession.persist_devices(devices, %{id: 1, subnet: "192.168.1.1"})
    second_count = List.first Repo.all(from d in DevicePresence.Device, select: count(d.id))
    DevicePresence.PersistSession.persist_devices(devices, %{id: 1, subnet: "192.168.1.1"})
    third_count = List.first Repo.all(from d in DevicePresence.Device, select: count(d.id))

    assert second_count == third_count
  end
end