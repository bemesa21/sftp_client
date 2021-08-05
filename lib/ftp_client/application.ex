defmodule SftpClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp poolboy_config do
    [
      name: {:local, :worker},
      worker_module: SftpClient.ConnectionWorker,
      size: 3,
      max_overflow: 2
    ]
  end

  @impl true
  def start(_type, _args) do
    SftpClient.Telemetry.StatsdReporter.connect()

    :ok =
      :telemetry.attach_many(
        "sftp_events_collector",
        SftpClient.Telemetry.Metrics.handled_events(),
        &SftpClient.Telemetry.Metrics.handle_event/4,
        nil
      )

    children = [
      :poolboy.child_spec(:worker, poolboy_config())
      # Starts a worker by calling: SftpClient.Worker.start_link(arg)
      # {SftpClient.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SftpClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
