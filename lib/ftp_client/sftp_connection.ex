defmodule FtpClient.SftpConnection do
  defstruct [:pid, :ref, :remote_params]

  @type t :: %__MODULE__{}

  alias FtpClient.ConnectionParams

  @sftp_client Application.get_env(:ftp_client, :client)

  def init_channel do
    params = ConnectionParams.fetch()
    start_sftp_channel(params)
  end

  defp start_sftp_channel(params) do
    case @sftp_client.start_channel(params.host, params.port, ConnectionParams.opts(params)) do
      {:ok, channel_pid, connection_ref} ->
        remote_params = FtpClient.RemoteParams.fetch()

        connection = %FtpClient.SftpConnection{
          pid: channel_pid,
          ref: connection_ref,
          remote_params: remote_params
        }

        {:ok, connection}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
