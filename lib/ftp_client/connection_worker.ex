defmodule FtpClient.ConnectionWorker do
  use GenServer
  require Logger
  @impl true
  def init(_stack) do
    case FtpClient.SftpConnection.init_channel() do
      {:ok, channel} ->
        {:ok, channel}

      {:error, error} ->
        {:stop, error}
    end
  end

  @spec start_link(any()) :: any()
  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def handle_call({:write, data, name}, _from, channel) do
    result = FtpClient.write_file(channel, data, name)
    {:reply, result, channel}
  end
end
