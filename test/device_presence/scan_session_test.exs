defmodule DevicePresence.ScanSessionTest do
  use ExUnit.Case, async: true

  test "will produce a list of nodes" do
    file = File.read!(Path.expand("test/fixtures/session.txt"))
    assert DevicePresence.ScanSession.nodes(file)
  end

  test "will produce a list of events" do
    file = File.read!(Path.expand("test/fixtures/session.txt"))
    [head | tail] = DevicePresence.ScanSession.events(file)

    assert head[:id] == "1"
    assert head[:node] == "72610428"
    assert List.first(tail)[:oldnode] == "726004C8"
  end

  test "will extract timestamps out " do
    file = File.read!(Path.expand("test/fixtures/session.txt"))
    [head | tail] = DevicePresence.ScanSession.events(file) |> Enum.filter(fn(event) -> Keyword.has_key?(event, :time) end)

    assert head[:id] == "1"
    assert "2016" == head[:time] |> Timex.format!("{YYYY}")
  end
end
