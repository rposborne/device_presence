defmodule DevicePresence.CollectorController do
  use DevicePresence.Web, :controller

  alias DevicePresence.Collector
  alias DevicePresence.Location

  def index(conn, %{"location_id" => location_id}) do
    location = Repo.get!(Location, location_id)
    collectors = Repo.all(Collector)
    render(conn, "index.html", collectors: collectors, location: location)
  end

  def new(conn, %{"location_id" => location_id}) do
    location = Repo.get!(Location, location_id)
    changeset = Collector.changeset(%Collector{location_id: location_id})
    render(conn, "new.html", changeset: changeset, location: location)
  end

  def create(conn, %{"collector" => collector_params}) do
    changeset = Collector.changeset(%Collector{api_key: SecureRandom.base64(32)}, collector_params)

    case Repo.insert(changeset) do
      {:ok, collector} ->
        conn
        |> put_flash(:info, "Collector created successfully.")
        |> redirect(to: location_collector_path(conn, :show, collector))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    collector = Repo.get!(Collector, id)
    devices = Repo.all assoc(collector, :devices)
    render(conn, "show.html", collector: collector, devices: devices)
  end

  def show_online(conn, %{"id" => id}) do
    collector = Repo.get!(Collector, id)
    users = collector |>  Collector.online_users |> Repo.all
    render(conn, "show_online.html", collector: collector, users: users)
  end

  def edit(conn, %{"id" => id}) do
    collector = Repo.get!(Collector, id)
    changeset = Collector.changeset(collector)
    render(conn, "edit.html", collector: collector, changeset: changeset)
  end

  def update(conn, %{"id" => id, "collector" => collector_params}) do
    collector = Repo.get!(Collector, id)
    changeset = Collector.changeset(collector, collector_params)

    case Repo.update(changeset) do
      {:ok, collector} ->
        conn
        |> put_flash(:info, "Collector updated successfully.")
        |> redirect(to: location_collector_path(conn, :show, collector))
      {:error, changeset} ->
        render(conn, "edit.html", collector: collector, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    collector = Repo.get!(Collector, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(collector)

    conn
    |> put_flash(:info, "Collector deleted successfully.")
    |> redirect(to: location_collector_path(conn, :index, collector.id))
  end
end
