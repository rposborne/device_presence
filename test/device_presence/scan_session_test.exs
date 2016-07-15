defmodule DevicePresence.ScanSessionTest do
  use ExUnit.Case, async: true

  test "will produce a list of nodes" do
    file = File.read!(Path.expand("test/fixtures/session.txt"))
    assert DevicePresence.ScanSession.nodes(file)
  end

  test "will print a list of nodes" do
    file = File.read!(Path.expand("test/fixtures/session.txt"))
    assert DevicePresence.ScanSession.persist_session(file)
  end

  test "will produce a list of events" do
    file = File.read!(Path.expand("test/fixtures/session.txt"))
    [head | tail] = DevicePresence.ScanSession.events(file)

    assert head[:id] == "61"
    assert head[:node] == "1039260"
    assert List.first(tail)[:oldnode] == "1036018"
  end

  test "will extract timestamps out " do
    file = File.read!(Path.expand("test/fixtures/session.txt"))
    [head | _tail] = DevicePresence.ScanSession.events(file) |> Enum.filter(fn(event) -> Map.has_key?(event, :time) end)

    assert head[:id] == "61"
    assert "2016" == head[:time] |> Timex.format!("{YYYY}")
  end
end
