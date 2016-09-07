defmodule DevicePresence.ScanSession do
  require DevicePresence.PersistSession
  require IEx
  use Timex

  def fetch_session do
    fetch_session('10.0.1.52')
  end

  def fetch_session(collector) do
    :inets.start
    case :httpc.request(:get, {"http://#{collector.subnet}/session.txt", []}, [], []) do
      {:ok, response} ->
        {_status_line, _headers, body} = response

        body |> List.to_string |> persist_session

      {:error, _response} ->
        %{}
    end

  end

  def persist_session(body) do
    body |> devices |> DevicePresence.PersistSession.persist_devices

    body |> events |> DevicePresence.PersistSession.persist_events
  end

  def devices(body) do
    scan_session(body, "node.")
  end

  def events(body) do
    scan_session(body, "log.event.")
  end

  def scan_session(body, filter) do
    relevant_lines = body |> String.split("\n") |> Enum.filter(fn(x) -> String.starts_with?(x, filter) end)

    lines = Enum.map(relevant_lines, fn(l) -> parse_line(l) end)
    # TODO: This is painful... Store in Map, and then strp groupings? must be
    # better way
    lines |> Enum.reduce(%{}, fn(l, acc) ->
      list = Map.get(acc, l[:id]) || []
      Map.put(acc, l[:id], Keyword.merge(list, l))
    end) |> Map.values |> Enum.map(fn el -> Enum.into(el, %{}) end)
  end

  def parse_line(line) do
    [key | value] = String.split(line, "=")
    value = List.first(value)
    case String.split(key, ".") do
      [_klass, _type, id, field] -> [{:id, id}, parse_field(field, value)]
      [_klass, id, field] -> [{:id, id}, parse_field(field, value)]
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
