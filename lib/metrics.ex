defmodule SftpClient.Telemetry.Metrics do
  require Logger
  alias SftpClient.Telemetry.StatsdReporter

  @handled_events [
    [:sftp_client, :connection, :stablished],
    [:sftp_client, :file, :created]
  ]

  def handled_events() do
    @handled_events
  end

  def handle_event([:sftp_client, :connection, :stablished], measurements, metadata, _config) do
    StatsdReporter.timing("sftp_client_connection_stablished", measurements.execution_time)

    Logger.info(
      "Received [:sftp_client, :startup, :pool] event. Connection stablished in: #{
        measurements.execution_time
      }, Pid: #{inspect(metadata.pid)}"
    )
  end

  def handle_event([:sftp_client, :file, :created], measurements, metadata, _config) do
    StatsdReporter.timing("sftp_client_file_created", measurements.execution_time)
    StatsdReporter.increment("sftp_client_file_created", 1)

    Logger.info(
      "Sftp client created #{metadata.filename}  in: #{measurements.execution_time} nanoseconds"
    )
  end
end
