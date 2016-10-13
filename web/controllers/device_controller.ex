defmodule DevicePresence.DeviceController do
  use DevicePresence.Web, :controller

  alias DevicePresence.Device
  alias DevicePresence.User

  def index(conn, _params) do
    devices = Repo.all(Device)
    render(conn, "index.html", devices: devices)
  end

  def new(conn, _params) do
    changeset = Device.changeset(%Device{})
    users = Repo.all(User)
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"device" => device_params}) do
    changeset = Device.changeset(%Device{}, device_params)

    case Repo.insert(changeset) do
      {:ok, _device} ->
        conn
        |> put_flash(:info, "Device created successfully.")
        |> redirect(to: device_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)
    events = Repo.all assoc(device, :events)
    render(conn, "show.html", device: device, events: events)
  end

  def edit(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)
    users = Repo.all(User)
    changeset = Device.changeset(device)
    render(conn, "edit.html", device: device, users: users, changeset: changeset)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = Repo.get!(Device, id)
    changeset = Device.changeset(device, device_params)

    case Repo.update(changeset) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device updated successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, changeset} ->
        render(conn, "edit.html", device: device, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(device)

    conn
    |> put_flash(:info, "Device deleted successfully.")
    |> redirect(to: device_path(conn, :index))
  end
end
