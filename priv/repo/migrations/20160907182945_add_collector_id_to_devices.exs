defmodule DevicePresence.Repo.Migrations.AddCollectorIdToDevices do
  use Ecto.Migration

  def change do
    alter table(:devices) do
      add :collector_id, :integer
    end
  end
end
