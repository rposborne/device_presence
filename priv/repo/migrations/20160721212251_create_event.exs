defmodule DevicePresence.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :device_id, :integer
      add :event_type, :string
      add :occured_at, :datetime
      add :collector_id, :integer
      timestamps
    end

  end
end
