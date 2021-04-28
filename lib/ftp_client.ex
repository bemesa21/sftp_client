defmodule FtpClient do
  @moduledoc """
  Documentation for `FtpClient`.
  """
  @sftp_client Application.get_env(:ftp_client, :client)

  alias FtpClient.SftpConnection

  def write(data, name) do
    :poolboy.transaction(
      :worker,
      fn pid -> GenServer.call(pid, {:write, data, name}) end,
      5000
    )
  end

  @doc """
  write_file/3 Writes a file to the server, by default in the user directory
  The file is created if it does not exist but overwritten if it exists.
  """
  @spec write_file(SftpConnection.t(), binary(), charlist()) ::
          {:ok, charlist()} | {:error, :atom}
  def write_file(channel, data, file_name) do
    file_path = channel.remote_params.path <> file_name
    result = @sftp_client.write_file(channel.pid, file_path, data)

    case result do
      :ok -> {:ok, file_path}
      {:error, reason} -> {:error, reason}
    end
  end
end
