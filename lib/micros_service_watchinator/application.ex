require Logger

defmodule MicroServiceWatchinator.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    Logger.info("Starting checks")
    children = [
      MicroServiceWatchinator.ConsumerWebsocketCheck
    ]
    Enum.each(children, fn me -> me.do_check() end)
    {:ok, self()}
  end

end
