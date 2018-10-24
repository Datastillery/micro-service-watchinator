ExUnit.start()

defmodule MicroServiceWatchinatorTest do
  use ExUnit.Case
  use Placebo
  alias StreamingMetrics.ConsoleMetricCollector, as: MetricCollector

  @expected_url "wss://foo.noop/socket/websocket"

  setup_all do
    System.put_env("CONSUMER_URI", @expected_url)
  end

  test "initiates websocket request" do
      allow WebSockex.start_link(@expected_url, any(), any(), [{:async, false}]),
        return: {:ok, "It worked"}

      assert MicroServiceWatchinator.ConsumerWebsocketCheck.do_check() == {:ok, "It worked"}
  end

  test "Submits the response metric to cloudwatch" do
    metric_map = %{
      dimensions: [{"ApplicationName", "Cota-Streaming-Consumer"}],
      metric_name: "Opened",
      timestamp: any(),
      unit: "Count",
      value: 1
    }

    allow WebSockex.start_link(any(), any(), any(), any()),
      return: {:ok, "It worked"}
    allow MetricCollector.count_metric(1, "Opened", [{"ApplicationName", "Cota-Streaming-Consumer"}]),
      return: metric_map
    expect MetricCollector.record_metrics([metric_map], "Socket Connection"),
      return: {:ok, %{}}

      assert MicroServiceWatchinator.ConsumerWebsocketCheck.do_check() == {:ok, "It worked"}
  end

  test "error gets handled" do
    allow WebSockex.start_link(@expected_url, any(), any(), [{:async, false}]),
      return: {:error, "It blew up"}
    assert MicroServiceWatchinator.ConsumerWebsocketCheck.do_check() == {:ok, "It blew up"}
  end
end
