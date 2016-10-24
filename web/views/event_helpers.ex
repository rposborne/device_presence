defmodule DevicePresence.EventHelpers do
  @moduledoc """
  Conveniences for display uptime status.
  """

  use Phoenix.HTML

  def __using__(_opt) do
  end

  @doc """
  Generates tag for inlined form input errors.
  """
  def offline_icon(msg) do
    if msg == "offline" do
      content_tag(:span, "▼ #{msg}", class: "device-down")
    else
      content_tag(:span, "▲ #{msg}", class: "device-up")
    end
  end

  def timeago_tag(time) do
    timezone = Timex.Timezone.get("America/New_York", time)
    time_formatted = Timex.Timezone.convert(time, timezone)
    time_formatted = Timex.format!(time_formatted, "{ISO:Extended:Z}")
    content_tag(:time, time_formatted, class: "timeago", datetime: time_formatted )
  end
end
