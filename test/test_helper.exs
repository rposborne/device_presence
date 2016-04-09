ExUnit.start

Mix.Task.run "ecto.create", ~w(-r DevicePresence.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r DevicePresence.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(DevicePresence.Repo)

