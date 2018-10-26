require Logger

defmodule MicroServiceWatchinator.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    Logger.info("Starting checks")
    children = [
      MicroServiceWatchinator.ConsumerWebsocketCheck
    ]

    opts = [strategy: :one_for_one, name: MicroServiceWatchinator.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
