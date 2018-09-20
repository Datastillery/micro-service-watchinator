defmodule MyApp.Client do
  use WebSockex

  def start_link(state) do
    {:ok, pid} = WebSockex.start_link("wss://streaming.smartcolumbusos.com/socket/websocket", __MODULE__, %{})
    WebSockex.send_frame(pid, {:text, "{\"topic\":\"vehicle_position\",\"event\":\"phx_join\",\"payload\":{},\"ref\":\"1\"}"})
    Process.sleep(1000)
    {:ok, pid}
  end

  def handle_connect(_conn, state) do
    IO.inspect "Inside connect handler"
    {:ok, state}
  end

  def handle_disconnect(%{reason: reason}, state) do
    IO.puts "websocket closing: #{inspect reason}"
    {:ok, state}
  end

  def handle_frame({type, msg}, state) do
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    {:ok, state}
  end
end

defmodule MicroServiceWatchinator.Application do
  use Application
  use WebSockex


  def start(_type, _args) do


    IO.puts "Hello......"

    children = [{MyApp.Client, []}]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
