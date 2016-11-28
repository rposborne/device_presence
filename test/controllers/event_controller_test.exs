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
    user |> with_pending_events
    conn = get conn, event_path(conn, :for_date, Timex.now("America/New_York") |> Timex.format!("%Y-%m-%dT%H:%M:%S.0Z%:z", :strftime) , %{user_id: user.id})
    events = json_response(conn, 200)["data"]
    first_event =  events |> List.first

    assert first_event["duration_in_minutes"] == 5
  end
end

"2016-04-17T11:05:25.787Z-05:00"
