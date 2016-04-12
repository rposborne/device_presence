defmodule DevicePresence.ScanSession do
  use GenServer
  use Timex
  require Logger
  require IEx

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 1 * 60 * 1000) # In 2 seconds
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    IO.puts "Running Scan Session worker"
    fetch_session
    # Start the timer again
    Process.send_after(self(), :work, 1 * 60 * 1000) # In 1 minute

    {:noreply, state}
  end

  def fetch_session do
    :inets.start
    case :httpc.request(:get, {'http://10.1.10.49/session.txt', []}, [], []) do
      {:ok, response} ->
        {_status_line, _headers, body} = response
        List.to_string(body) |> events
    end
  end

  def persist_session(body) do
    Enum.each(events(body), fn(x) -> IO.puts x[:id] end)
  end

  def nodes(body) do
    scan_session(body, "node.")
  end

  def events(body) do
    scan_session(body, "log.event")
  end

  def scan_session(body, filter) do
    relevant_lines = String.split(body, "\n") |> Enum.filter(fn(x) -> String.contains?(x, filter) end)

    lines = Enum.map(relevant_lines, fn(l) -> parse_line(l) end)
    # TODO: This is painful... Store in Map, and then strp groupings? must be
    # better way
    Enum.reduce( lines, %{}, fn(l, acc) ->
      list = Map.get(acc, l[:id]) || []
      Map.put(acc, l[:id], Keyword.merge(list, l))
    end) |> Map.values |> Enum.map(fn el -> Enum.into(el, %{}) end)
  end

  def parse_line(line) do
    [key | value] = String.split(line, "=")
    value = List.first(value)
    case String.split(key, ".") do
      [klass, _type, id, field] -> [{:id, id}, parse_field(field, value)]
      [klass, id, field] -> [{:id, id}, parse_field(field, value)]
    end
  end

  def parse_field(key, value) do
    key = String.to_atom(key)
    value = case key do
      :oldnode -> parse_node_value(value)
      :node -> parse_node_value(value)
      :time -> DateTime.from_seconds(String.to_float(value), :epoch)
      :prevtime -> DateTime.from_seconds(String.to_float(value), :epoch)
      _ -> value
    end

    {key , value}
  end

  defp parse_node_value(node_value_string) do
    List.last(String.split(node_value_string, "."))
  end
end
