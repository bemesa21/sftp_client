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

  def handle_call({:list, path}, _from, channel) do
    result = FtpClient.list_files(channel, path)
    {:reply, result, channel}
  end

  def handle_call({:create_dir, path}, _from, channel) do
    result = FtpClient.create_directory(channel, path)
    {:reply, result, channel}
  end

  def handle_call({:read_file, path}, _from, channel) do
    result = FtpClient.read_file(channel, path)
    {:reply, result, channel}
  end
end
