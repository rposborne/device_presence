defmodule DevicePresence.Repo.Migrations.CreateCollector do
  use Ecto.Migration

  def change do
    create table(:collectors) do
      add :name, :string
      add :location, :string
      add :subnet, :string

      timestamps()
    end

  end
end
