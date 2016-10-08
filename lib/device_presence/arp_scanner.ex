defmodule ArpScanner do
  def scan do
    {output, _exit_code} = System.cmd("arp-scan", ["--localnet", "--quiet"])

    output |> String.split("\n") |> extract_mac_address
  end

  def extract_mac_address(lines) do
    lines |> Enum.filter(fn line -> Regex.match?(~r/([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/, line) end)
  end
end