defmodule FtpClient.ConnectionParams do
  defstruct [
    :host,
    :port,
    :user,
    :password,
    :user_interaction,
    :silently_accept_hosts,
    :rekey_limit
  ]

  alias FtpClient.ConnectionParams

  @type t :: %__MODULE__{}

  def fetch() do
    opts = Application.get_env(:ftp_client, __MODULE__)
    struct(ConnectionParams, opts)
  end

  @spec opts(ConnectionParams.t()) :: list()
  def opts(params) do
    [
      user_interaction: params.user_interaction,
      silently_accept_hosts: params.silently_accept_hosts,
      rekey_limit: params.rekey_limit,
      user: params.user,
      password: params.password
    ]
  end
end
