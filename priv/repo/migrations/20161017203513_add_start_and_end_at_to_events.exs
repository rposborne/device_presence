defmodule DevicePresence.Repo.Migrations.AddStartAndEndAtToEvents do
  use Ecto.Migration

  def change do
    rename table(:events), :occured_at, to: :started_at
    alter table(:events) do
      add :ended_at, :datetime
    end
  end
end
