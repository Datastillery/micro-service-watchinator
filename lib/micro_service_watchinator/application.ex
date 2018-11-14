require Logger

defmodule MicroServiceWatchinator.MetricsExporter do
  @moduledoc """
    A module for exporting beam metrics to prometheus
  """
  use Prometheus.PlugExporter
end

defmodule MicroServiceWatchinator.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    Logger.info("Starting checks")
    MicroServiceWatchinator.MetricsExporter.setup()

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: MicroServiceWatchinator.MetricsExporter,
        options: [port: port()]
      ),
      MicroServiceWatchinator.ConsumerWebsocketCheck
    ]

    opts = [strategy: :one_for_one, name: MicroServiceWatchinator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def port() do
    Application.get_env(:micro_service_watchinator, :metrics_port, 4002)
  end
end
