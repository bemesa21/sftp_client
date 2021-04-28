use Mix.Config

config :ftp_client, :client, FtpClient.Mock

config :ftp_client, FtpClient.ConnectionParams,
  host: '',
  port: 22,
  user: '',
  password: '',
  user_interaction: false,
  silently_accept_hosts: true,
  rekey_limit: 1_000_000_000_000

config :ftp_client, FtpClient.RemoteParams,
  path: "/home/",
  permissions: [:write, :binary, :creat]
