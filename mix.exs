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
      mod: {MicroServiceWatchinator.Application, []},
      extra_applications: [:logger]
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
      {:streaming_metrics, path: "streaming_metrics"},
      {:httpoison, "~> 0.11.1"},
      {:cachex, "~> 3.0"},
      {:poison, "~> 4.0"},
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false},
      {:placebo, "~> 0.2", only: [:dev, :test]},
      {:distillery, "~> 2.0"}
    ]
  end
end
