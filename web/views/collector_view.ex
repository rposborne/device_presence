defmodule DevicePresence.CollectorView do
  use DevicePresence.Web, :view

  def offline_icon(msg) do
    if msg == "offline" do
      content_tag(:span, "▼ #{msg}", class: "device-down")
    else
      content_tag(:span, "▲ #{msg}", class: "device-up")
    end
  end
end
