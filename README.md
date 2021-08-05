# SftpClient

This is a wrapper around the `:ssh_sftp` erlangs library.
It uses `poolboy` to create n connections when the application is started.
By doing so you avoid to create a new connection every time that you need to 
read, write or list the files in the ssh server.

Also there are some metrics reporting implemented with `telemetry`and `statix`


## Configuration

You have to change your dev configurations in `dev.exs`
```elixir

config :ftp_client, SftpClient.ConnectionParams,
  host: '',
  port: 22,
  user: '',
  password: '',
  user_interaction: false,
  silently_accept_hosts: true,
  rekey_limit: 1_000_000_000_000

config :ftp_client, SftpClient.RemoteParams,
  path: "/home/",
  permissions: [:write, :binary, :creat]
  ```
the most important configurations are:
- host: your sftp server url
- user: your authorized user
- passworf: your sftp password
- path: it has to be a directory that exists in the sftp server

Also you can specify how many connections you want in `application.ex` by changing the pool `size`:
```elixir
  defp poolboy_config do
    [
      name: {:local, :worker},
      worker_module: SftpClient.ConnectionWorker,
      size: 3,
      max_overflow: 2
    ]
  end
```

## Usage
Run an IEx session

`iex -S mix`

You will see this logs if there are no errors
```
21:58:23.742 [info]  Received [:sftp_client, :startup, :pool] event. Connection stablished in: 10108948000, Pid: #PID<0.292.0>
```

- You can write a file:

```elixir
SftpClient.write("some conteeeent", "my_file.txt")
```

- You can read a file:

```elixir
SftpClient.read("test_dir/my_file.txt")
```

- You can list the files in some directory:

```elixir
SftpClient.list("test_dir/")
```

- You can create a new directory:

```elixir
SftpClient.create_dir("my_new_dir/")
```
