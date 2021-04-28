defmodule FtpClient.RemoteParams do
  defstruct [:path, :permissions]
  alias FtpClient.RemoteParams

  def fetch do
    opts = Application.get_env(:ftp_client, __MODULE__)
    struct(RemoteParams, opts)
  end
end
