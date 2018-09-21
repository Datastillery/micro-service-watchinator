ExUnit.start()

defmodule MicroServiceWatchinatorTest do
  use ExUnit.Case

  import Mock
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
      assert MicroServiceWatchinator.ConsumerWebsocketCheck.start_link(%{}) == {:ok, "It worked"}
    end
  end

  # test "Submits the response metric to cloudwatch" do
  #   with_mocks([
  #     {WebSockex, [],
  #      [
  #        start_link: fn _url, _module, _params, _options ->
  #          {:ok, "It worked"}
  #       end
  #      ]},
  #     {MetricCollector, [:passthrough],
  #      [
  #        record_metrics: fn _metrics, "Socket Connection" ->
  #          {:ok, %{}}
  #        end
  #      ]
  #     }
  #   ]) do
  #     assert MicroServiceWatchinator.ConsumerWebsocketCheck.start_link(%{}) == {:ok, "It worked"}

  #     assert called(
  #       MetricCollector.(
  #         "wss://foo.noop/socket/websocket",
  #         MicroServiceWatchinator.ConsumerWebsocketCheck,
  #         %{},
  #         [{:async, false}]
  #       )
  #     )
  #   end
  # end
end
