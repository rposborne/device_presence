defmodule DevicePresence.Repo.Migrations.AddCollectorIdToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :collector_id, :integer
    end
  end
end
