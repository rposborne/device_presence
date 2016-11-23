defmodule DevicePresence.CollectorControllerTest do
  use DevicePresence.ConnCase
  import DevicePresence.Factory

  alias DevicePresence.Collector
  @valid_attrs %{type: "slack_presence", name: "some content"}
  @invalid_attrs %{}

  setup do
     {:ok, %{conn: guardian_login(insert(:user)), location: insert(:location)}}
  end

  test "lists all entries on index", %{conn: conn, location: location} do
    conn = get conn, location_collector_path(conn, :index, location.id)
    assert html_response(conn, 200) =~ "Collectors"
  end

  test "renders form for new resources", %{conn: conn, location: location} do
    conn = get conn, location_collector_path(conn, :new, location.id)
    assert html_response(conn, 200) =~ "New collector"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, location: location} do
    valid_attrs = @valid_attrs |> Map.merge(%{location_id: location.id })
    conn = post conn, location_collector_path(conn, :create, location.id), collector: valid_attrs
    assert redirected_to(conn) == location_collector_path(conn, :index, location.id)

    assert Repo.get_by(Collector, valid_attrs )
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, location: location} do
    conn = post conn, location_collector_path(conn, :create, location.id), collector: @invalid_attrs
    assert html_response(conn, 200) =~ "New collector"
  end

  test "shows chosen resource", %{conn: conn, location: location} do
    collector = Repo.insert! %Collector{location: location}
    conn = get conn, location_collector_path(conn, :show, collector)
    assert html_response(conn, 200) =~ "Collector"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, location_collector_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, location: location} do
    collector = Repo.insert! %Collector{location: location}
    conn = get conn, location_collector_path(conn, :edit, collector)
    assert html_response(conn, 200) =~ "Edit collector"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, location: location} do
    collector = Repo.insert! %Collector{location: location}
    conn = put conn, location_collector_path(conn, :update, collector), collector: @valid_attrs
    assert redirected_to(conn) == location_collector_path(conn, :show, collector)
    assert Repo.get_by(Collector, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, location: location} do
    collector = Repo.insert! %Collector{location: location}
    conn = put conn, location_collector_path(conn, :update, collector), collector: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit collector"
  end

  test "deletes chosen resource", %{conn: conn, location: location} do
    collector = Repo.insert! %Collector{location: location}
    conn = delete conn, location_collector_path(conn, :delete, collector)
    assert redirected_to(conn) == location_collector_path(conn, :index, location.id)
    refute Repo.get(Collector, collector.id)
  end
end
