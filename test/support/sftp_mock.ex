defmodule FtpClient.Mock do
  def open(_connection, _remote_path, _mode) do
    {:ok, {}}
  end

  def write_file(_channel_pid, _path, _data) do
    :ok
  end

  def start_channel(_host, _port, _opts) do
    {:ok, {}, {}}
  end
end
