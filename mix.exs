defmodule MicroServiceWatchinator.MixProject do
  use Mix.Project

  def project do
    [
      app: :micro_service_watchinator,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:websockex],
      mod: {MicroServiceWatchinator.Application, []},
      # extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:websockex, "~> 0.4.0"},
      {:streaming_metrics, git: "git@github.com:SmartColumbusOS/streaming-metrics", tag: "1.0.0"},
      {:cachex, "~> 3.0"}
    ]
  end
end
