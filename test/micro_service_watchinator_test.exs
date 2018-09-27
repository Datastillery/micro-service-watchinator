ExUnit.start()

defmodule MicroServiceWatchinatorTest do
  use ExUnit.Case

  import Mock
  import MockHelper
  alias StreamingMetrics.ConsoleMetricCollector, as: MetricCollector

  @expected_url "wss://foo.noop/socket/websocket"

  setup_all do
    System.put_env("CONSUMER_URI", @expected_url)
  end

  test "initiates websocket request" do
    with_mocks([
      {WebSockex, [],
       [
         start_link: fn @expected_url, _module, _params, [{:async, false}] ->
           {:ok, "It worked"}
         end
       ]}
    ]) do
      assert MicroServiceWatchinator.ConsumerWebsocketCheck.do_check() == {:ok, "It worked"}
    end
  end

  test "Submits the response metric to cloudwatch" do
    with_mocks([
      {WebSockex, [],
       [
         start_link: fn _url, _module, _params, _options ->
           {:ok, "It worked"}
         end
       ]},
      {MetricCollector, [:passthrough],
       [
         record_metrics: fn [
                              %{
                                dimensions: [{"ApplicationName", "Cota-Streaming-Consumer"}],
                                metric_name: "Opened",
                                timestamp: _,
                                unit: "Count",
                                value: 1
                              }
                            ],
                            "Socket Connection" ->
           {:ok, %{}}
         end
       ]}
    ]) do
      assert MicroServiceWatchinator.ConsumerWebsocketCheck.do_check() == {:ok, "It worked"}

      assert called_times(1, MetricCollector.record_metrics(:_, "Socket Connection"))
    end
  end

  test "error gets handled" do
    with_mocks([
      {WebSockex, [],
       [
         start_link: fn @expected_url, _module, _params, [{:async, false}] ->
           {:error, "It blew up"}
         end
       ]}
    ]) do
      assert MicroServiceWatchinator.ConsumerWebsocketCheck.do_check() == {:ok, "It blew up"}
    end
  end
end
