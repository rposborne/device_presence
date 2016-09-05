defmodule DevicePresence.DeviceControllerTest do
  use DevicePresence.ConnCase

  alias DevicePresence.Device
  @valid_attrs %{last_seen_at: "2010-04-17 14:00:00", mac_address: "01:23:45:67:89:ab", name: "iPhone", user_id: 42, fing_node: "0032"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, device_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = get conn, device_path(conn, :show, device)
    assert json_response(conn, 200)["data"] == %{"id" => device.id,
      "name" => device.name,
      "mac_address" => device.mac_address,
      "last_seen_at" => device.last_seen_at,
      "user_id" => device.user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, device_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Device, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = put conn, device_path(conn, :update, device), device: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Device, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = put conn, device_path(conn, :update, device), device: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = delete conn, device_path(conn, :delete, device)
    assert response(conn, 204)
    refute Repo.get(Device, device.id)
  end
end
