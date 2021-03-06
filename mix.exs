defmodule DevicePresence.Mixfile do
  use Mix.Project

  def project do
    [app: :device_presence,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {DevicePresence, []},
     applications: [:phoenix,
                    :phoenix_html,
                    :phoenix_pubsub,
                    :cowboy,
                    :logger,
                    :gettext,
                    :phoenix_ecto,
                    :postgrex,
                    :timex,
                    :timex_ecto,
                    :distillery,
                    :secure_random,
                    :guardian,
                    :ueberauth,
                    :ueberauth_google]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:phoenix_html, "~> 2.4"},
     {:timex, "~> 3.0" },
     {:timex_ecto, "~> 3.0.5"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:credo, "~> 0.4", only: [:dev, :test]},
     {:distillery, "~> 0.10"},
     {:cowboy, "~> 1.0"},
     {:secure_random, "~> 0.5"},
     {:guardian, "~> 0.13.0"},
     {:ueberauth, "~> 0.4"},
     {:ueberauth_google, "~> 0.4"},
     {:ex_machina, "~> 1.0", only: [:test]} ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
    "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]
   ]
  end
end
