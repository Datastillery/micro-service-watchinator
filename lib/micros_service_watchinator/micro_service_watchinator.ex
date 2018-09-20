defmodule MicroServiceWatchinator do
  @moduledoc """
  Documentation for MicroServiceWatchinator.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MicroServiceWatchinator.hello()
      :world

  """
  def start(_type, _args) do
    :world
    IO.puts "HELLO...."
    :ok
  end
end
