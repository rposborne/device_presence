defmodule DevicePresence.Repo.Migrations.CreateCollectorScan do
  use Ecto.Migration

  def change do
    create table(:collector_scans) do
      add :occurred_at, :datetime
      add :collector_id, references(:collectors, on_delete: :nothing)

      timestamps()
    end
    create index(:collector_scans, [:collector_id])

  end
end
