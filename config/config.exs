# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :device_presence, DevicePresence.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "KlGErXAJNXtZ7fu+q+R16KZIwta0citti3BQwvqUnQq6nhJWhxiSf2vcJRve6jqB",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: DevicePresence.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :device_presence, ecto_repos: [DevicePresence.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "DevicePresence",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: System.get_env("SECRET_KEY_BASE"),
  serializer: DevicePresence.GuardianSerializer
