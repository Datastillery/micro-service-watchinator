defmodule MicroServiceWatchinator.MixProject do
  use Mix.Project

  def project do
    [
      app: :micro_service_watchinator,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:websockex],
      mod: {MicroServiceWatchinator.Application, []}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:websockex, "~> 0.4.0"},
      {:streaming_metrics, git: "git@github.com:SmartColumbusOS/streaming-metrics", tag: "1.0.0"},
      {:mix_test_watch, "~> 0.6.0", only: :dev, runtime: false},
      {:mock, "~> 0.3.1", only: :test, runtime: false},
      {:cachex, "~> 3.0"}
    ]
  end
end
