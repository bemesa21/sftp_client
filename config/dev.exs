use Mix.Config

config :ftp_client, :client, :ssh_sftp

config :ftp_client, SftpClient.ConnectionParams,
  host: '',
  port: 22,
  user: '',
  password: '',
  user_interaction: false,
  silently_accept_hosts: true,
  rekey_limit: 1_000_000_000_000

config :ftp_client, SftpClient.RemoteParams,
  path: "test_dir/",
  permissions: [:write, :binary, :creat]
