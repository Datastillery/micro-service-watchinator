defmodule MicroServiceWatchinator.Application do
  use Application

  def start(_type, _args) do
    children = [
      MicroServiceWatchinator.ConsumerWebsocketCheck
    ]
    Enum.each(children, fn me -> me.do_check() end)
    {:ok, self()}
  end

end
