ExUnit.start()

defmodule MicroServiceWatchinatorTest do
  use ExUnit.Case

  import Mock

  test "initiates websocket request" do
    System.put_env("CONSUMER_URI", "wss://foo.noop/socket/websocket")

    with_mocks([
      {WebSockex, [], [start_link: fn _url, _module, _params, _options -> {:ok, "It worked"} end]}
    ]) do
      MicroServiceWatchinator.ConsumerWebsocketCheck.start_link(%{})

      assert_called(
        WebSockex.start_link(
          "wss://foo.noop/socket/websocket",
          MicroServiceWatchinator.ConsumerWebsocketCheck,
          %{},
          [{:async, false}]
        )
      )
    end
  end
end
