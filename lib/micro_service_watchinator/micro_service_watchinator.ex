require Logger

defmodule MicroServiceWatchinator.ConsumerWebsocketCheck do
  @moduledoc """
  This module connects to a consumer URI and sends connection metrics to be aggregated.
  """

  use WebSockex
  @metric_collector Application.get_env(:streaming_metrics, :collector)

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    do_check()
    schedule_work()
    {:ok, nil}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 60_000)
  end

  def handle_info(:work, state) do
    do_check()
    schedule_work()
    noreply(state)
  end

  defp noreply(new_state), do: {:noreply, new_state}

  def do_check do
    Logger.info("Initiating web check against #{System.get_env("CONSUMER_URI")}")

    case WebSockex.start_link(System.get_env("CONSUMER_URI"), __MODULE__, %{}, async: false) do
      {:ok, data} ->
        Logger.info("Successfully Made Socket Connection")

        1
        |> @metric_collector.count_metric("Opened", [
          {"ApplicationName", "Cota-Streaming-Consumer"}
        ])
        |> List.wrap()
        |> @metric_collector.record_metrics("Socket Connection")

        {:ok, data}

      {:error, err} ->
        Logger.warn("Failed to make a socket connection")
        {:ok, err}
    end
  end
end
