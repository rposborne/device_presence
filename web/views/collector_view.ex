defmodule DevicePresence.CollectorView do
  use DevicePresence.Web, :view
  import DevicePresence.EventHelpers

  def user_name(device) do
    if device.user do
      device.user.name
    end
  end
end
