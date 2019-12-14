defmodule WebServer.HelloWorldPlug do
  import Plug.Conn

  # called by supervision tree
  def init(options) do
    options
  end

  # called for every request from Cowboy
  # req: %Plug.Conn{}
  # res: %Plug.Conn{}
  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello World!\n")
  end
end
