defmodule DevicePresence.EventControllerTest do
  use DevicePresence.ConnCase
  import DevicePresence.Factory
  @valid_attrs %{}
  @invalid_attrs %{}
  @device_id 1
  @user_id 1

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all events for a device", %{conn: conn} do
    conn = get conn, event_path(conn, :index, %{device_id: @device_id})
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all events for a user", %{conn: conn} do
    conn = get conn, event_path(conn, :index, %{user_id: @user_id})
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all events for a user for a given day", %{conn: conn} do
    user = insert(:user)
    user |> with_events
    conn = get conn, event_path(conn, :for_date, "2016-04-17T11:05:25.787Z-05:00", %{user_id: user.id})
    first_event = json_response(conn, 200)["data"] |> List.first
    assert first_event["duration_in_minutes"] == 5
  end
end
