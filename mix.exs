defmodule MicroServiceWatchinator.MixProject do
  use Mix.Project

  def project do
    [
      app: :micro_service_watchinator,
      version: "1.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MicroServiceWatchinator.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      test: "test --no-start",
      lint: ["format", "credo"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:websockex, "~> 0.4.0"},
      {:streaming_metrics, "~> 2.2.0"},
      {:httpoison, "~> 1.5.0"},
      {:cachex, "~> 3.0"},
      {:poison, "~> 4.0"},
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false},
      {:placebo, "~> 0.2", only: [:dev, :test]},
      {:distillery, "~> 2.0"},
      {:plug_cowboy, "~> 2.0"},
      {:prometheus_plugs, "~> 1.1.1"}
    ]
  end
end
