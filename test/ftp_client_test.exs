defmodule FtpClientTest do
  use ExUnit.Case
  doctest FtpClient
  alias FtpClient.RemoteParams

  test "upload a file" do
    params = RemoteParams.fetch()
    result = FtpClient.write("Esto en un txt", "test.txt")
    assert result == {:ok, params.path <> "test.txt"}
  end
end
