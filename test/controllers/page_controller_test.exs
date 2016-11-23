defmodule DevicePresence.PageControllerTest do
  use DevicePresence.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Please Login"
  end
end
