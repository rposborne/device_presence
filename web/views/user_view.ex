defmodule DevicePresence.UserView do
  use DevicePresence.Web, :view
  use Timex
  import DevicePresence.EventHelpers

  def device_name(conn, device) do
    name = if device.name do
      device.name
    else
      device.mac_address
    end

    link name, to: device_path(conn, :show, device)
  end
end
