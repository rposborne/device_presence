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
end
