require Logger

defmodule MicroServiceWatchinator.ConsumerWebsocketCheck do

  use WebSockex
  @metric_collector Application.get_env(:streaming_metrics, :collector)

  def do_check do
    Logger.info("Initiating web check against #{System.get_env("CONSUMER_URI")}")
    case WebSockex.start_link(System.get_env("CONSUMER_URI"), __MODULE__, %{}, async: false) do
      {:ok, data} ->
        Logger.info("Successfully Made Socket Connection")
        @metric_collector.count_metric(1, "Opened", [{"Application Name", "Cota-Streaming-Consumer"}])
        |> List.wrap()
        |> @metric_collector.record_metrics("Socket Connection")
        {:ok, data}
      {:error, err} ->
        Logger.warn("Failed to make a socket connection")
        {:ok, err}
    end
  end

end
