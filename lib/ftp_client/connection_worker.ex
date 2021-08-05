defmodule SftpClient.ConnectionWorker do
  use GenServer
  require Logger
  @impl true
  def init(_stack) do
    start = System.monotonic_time()

    case SftpClient.SftpConnection.init_channel() do
      {:ok, channel} ->
        measurements = %{
          execution_time: get_execution_time(start)
        }

        :telemetry.execute([:sftp_client, :connection, :stablished], measurements, channel)
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
    start = System.monotonic_time()

    result = SftpClient.write_file(channel, data, name)

    metadata = %{
      filename: name
    }

    measurements = %{
      execution_time: get_execution_time(start)
    }

    :telemetry.execute([:sftp_client, :file, :created], measurements, metadata)

    {:reply, result, channel}
  end

  def handle_call({:list, path}, _from, channel) do
    result = SftpClient.list_files(channel, path)
    {:reply, result, channel}
  end

  def handle_call({:create_dir, path}, _from, channel) do
    result = SftpClient.create_directory(channel, path)
    {:reply, result, channel}
  end

  def handle_call({:read_file, path}, _from, channel) do
    result = SftpClient.read_file(channel, path)
    {:reply, result, channel}
  end

  defp get_execution_time(start_time) do
    end_time = System.monotonic_time()
    System.convert_time_unit(end_time - start_time, :native, :nanosecond)
  end
end
