defmodule DevicePresence.CollectorControllerTest do
  use DevicePresence.ConnCase

  alias DevicePresence.Collector
  @valid_attrs %{location_id: "1", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, location_collector_path(conn, :index, 1)
    assert html_response(conn, 200) =~ "Listing collectors"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, location_collector_path(conn, :new, 1)
    assert html_response(conn, 200) =~ "New collector"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, location_collector_path(conn, :create, 1), collector: @valid_attrs
    assert redirected_to(conn) == location_collector_path(conn, :index, 1)
    assert Repo.get_by(Collector, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, location_collector_path(conn, :create, 1), collector: @invalid_attrs
    assert html_response(conn, 200) =~ "New collector"
  end

  test "shows chosen resource", %{conn: conn} do
    collector = Repo.insert! %Collector{}
    conn = get conn, location_collector_path(conn, :show, collector)
    assert html_response(conn, 200) =~ "Show collector"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, location_collector_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    collector = Repo.insert! %Collector{}
    conn = get conn, location_collector_path(conn, :edit, collector)
    assert html_response(conn, 200) =~ "Edit collector"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    collector = Repo.insert! %Collector{}
    conn = put conn, location_collector_path(conn, :update, collector), collector: @valid_attrs
    assert redirected_to(conn) == location_collector_path(conn, :show, collector)
    assert Repo.get_by(Collector, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    collector = Repo.insert! %Collector{}
    conn = put conn, location_collector_path(conn, :update, collector), collector: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit collector"
  end

  test "deletes chosen resource", %{conn: conn} do
    collector = Repo.insert! %Collector{}
    conn = delete conn, location_collector_path(conn, :delete, collector)
    assert redirected_to(conn) == location_collector_path(conn, :index, 1)
    refute Repo.get(Collector, collector.id)
  end
end
