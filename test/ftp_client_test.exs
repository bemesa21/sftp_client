defmodule SftpClientTest do
  use ExUnit.Case
  alias SftpClient.RemoteParams

  test "upload a file" do
    params = RemoteParams.fetch()
    result = SftpClient.write("Esto en un txt", "test.txt")
    assert result == {:ok, params.path <> "test.txt"}
  end
end
