defmodule DevicePresence.CollectorController do
  use DevicePresence.Web, :controller

  alias DevicePresence.Collector


  def index(conn, _params) do
    collectors = Repo.all(Collector)
    render(conn, "index.html", collectors: collectors)
  end

  def new(conn, _params) do
    changeset = Collector.changeset(%Collector{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"collector" => collector_params}) do
    changeset = Collector.changeset(%Collector{}, collector_params)

    case Repo.insert(changeset) do
      {:ok, _collector} ->
        conn
        |> put_flash(:info, "Collector created successfully.")
        |> redirect(to: collector_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    collector = Repo.get!(Collector, id)
    devices = Repo.all assoc(collector, :devices)
    render(conn, "show.html", collector: collector, devices: devices)
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
        |> redirect(to: collector_path(conn, :show, collector))
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
    |> redirect(to: collector_path(conn, :index))
  end
end
