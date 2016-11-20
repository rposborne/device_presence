defmodule DevicePresence.Repo.Migrations.AddLocationIdToCollectors do
  use Ecto.Migration

  def change do
    alter table(:collectors) do
      add :location_id, references(:locations)
      add :api_key, :string
    end

    create unique_index(:collectors, [:api_key])
  end
end
