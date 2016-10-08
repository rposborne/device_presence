defmodule ArpScannerTest do
  use DevicePresence.ModelCase

  test "will return an array of tuples of mac address and " do
    ArpScanner.scan
  end
end