defmodule DevicePresence.PageController do
  use DevicePresence.Web, :controller
  use Guardian.Phoenix.Controller
  def index(conn, _params, current_user, _claims) do
    render conn, "index.html", current_user: current_user
  end
end
