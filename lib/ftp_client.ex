defmodule FtpClient do
  @moduledoc """
  Sftp client to manage all files operations
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

  def list(path) do
    :poolboy.transaction(
      :worker,
      fn pid -> GenServer.call(pid, {:list, path}) end,
      5000
    )
  end

  def create_dir(path) do
    :poolboy.transaction(
      :worker,
      fn pid -> GenServer.call(pid, {:create_dir, path}) end,
      5000
    )
  end

  def read(path) do
    :poolboy.transaction(
      :worker,
      fn pid -> GenServer.call(pid, {:read_file, path}) end,
      5000
    )
  end

  @doc """
  write_file/3 Writes a file to the server, by default in the user directory
  The file is created if it does not exist but overwritten if it exists.
  ## Examples

      iex> write_file(%SftpConnection{}, "hello", "test.txt")
      {:ok, "path/to/file/my_file.txt"}

      iex> write_file(%SftpConnection{}, "hello", "test.txt")
      {:error, :permission_denied}
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

  @doc """
  list_files/2 List the files in the given path, if it exists
  return a list of file_names

  ## Examples

      iex> list_files(%SftpConnection{}, '/existent_path/')
      {:ok, ['.', '..', 'my_file.txt']}

      iex> list_files(%SftpConnection{}, '/unexistent_path/')
      {:error, :no_such_file}
  """
  def list_files(channel, path) do
    :ssh_sftp.list_dir(channel.pid, path)
  end

  @doc """
  create_directory/2 Creates a directory specified by Name.
  Name must be a full path to a new directory.
  The directory can only be created in an existing directory.

  ## Examples

      iex> create_directory(%SftpConnection{}, '/existent_path/new_directory')
      :ok

      iex> create_directory(%SftpConnection{}, '/unexistent_path/new_directory')
      {:error, :no_such_file}
  """
  def create_directory(channel, directory_path) do
    result = :ssh_sftp.make_dir(channel.pid, directory_path)

    case result do
      :ok -> {:ok, directory_path}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  read_file/2 Read a file file_path.
  file_path can be an absolute path or the relative path from users directory.

  ## Examples

      iex> read_file(%FtpConnection{}, '/existent_path/my_file.txt')
      {:ok, "file content"}

      iex> read_file(%FtpConnection{}, '/existent_path/bad_file_name.txt')
      {:error, :no_such_file}
  """
  def read_file(channel, file_path) do
    :ssh_sftp.read_file(channel.pid, file_path)
  end
end
