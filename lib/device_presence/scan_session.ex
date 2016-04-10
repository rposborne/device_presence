defmodule DevicePresence.ScanSession do
  use GenServer
  use Timex
  require Logger
  require IEx

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 2 * 1000) # In 2 seconds
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    IO.puts "Running Scan Session worker"
    # parse_fing_session
    # Start the timer again
    Process.send_after(self(), :work, 2 * 1000) # In 2 seconds

    {:noreply, state}
  end

  def parse_fing_session(file) do
    {:ok, body} = file
    Enum.each(events(body), fn(x) -> IO.puts x end)
  end

  def nodes(body) do
    scan_session(body, "node.")
  end

  def events(body) do
    scan_session(body, "log.event")
  end

  def scan_session(file, filter) do
    relevant_lines = String.split(file) |> Enum.filter(fn(x) -> String.contains?(x, filter) end)

    grouped_lines = Enum.map(relevant_lines, fn(l) -> parse_line(l) end)

  end

  def parse_line(line) do
    [key | value] = String.split(line, "=")
    value = List.first(value)
    case String.split(key, ".") do
      [klass, _type, id, field] -> [{:id, id}, {:type, String.to_atom(klass)}, parse_field(field, value)]
      [klass, id, field] -> [{:id, id}, {:type, String.to_atom(klass)}, parse_field(field, value)]
    end
  end

  def parse_field(key, value) do
    key = String.to_atom(key)
    value = case key do
      :oldnode -> List.last(String.split(value, "."))
      :node -> List.last(String.split(value, "."))
      :time -> DateTime.from_seconds(String.to_float(value), :epoch)
      :prevtime -> DateTime.from_seconds(String.to_float(value), :epoch)
      _ -> value
    end

    {key , value}
  end
end
