defmodule TokenAuth do
  import Plug.Conn
  alias DevicePresence.Collector
  alias DevicePresence.Repo
  @realm "Basic realm=\"Thou Shalt not pass\""

  def init(opts) do
    opts
  end

  def call(conn, _params) do
    case get_req_header(conn, "authorization") do
      ["token " <> auth] ->
        case Repo.get_by(Collector, api_key: auth) do
          nil -> unauthorized(conn)
          collector ->
            assign(conn, :collector, collector)
        end
      _ ->
        unauthorized(conn)
    end
  end

  defp encode(username, password), do: Base.encode64(username <> ":" <> password)

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "unauthorized")
    |> halt()
  end
end
