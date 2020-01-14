defmodule WebServer.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias WebServer.Plug.VerifyRequest

  if Mix.env == :dev, do: use Plug.Debugger

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug VerifyRequest, fields: ["content", "mimetype"], paths: ["/upload"]
  plug Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["text/*", "application/*"],
    json_decoder: Jason
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/upload" do
    IO.inspect conn
    conn
    |> put_resp_content_type("application/json")
  	|> send_resp(201, Jason.encode!(conn.params))
    # send_resp(conn, 201, "Uploaded")
  end

  match _ do
    send_resp(conn, 404, "Oops")
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
  	IO.inspect(kind, label: :kind)
  	IO.inspect(reason, label: :reason)
  	IO.inspect(stack, label: :stack)
  	send_resp(conn, conn.status, "Something went wrong")
  end
end
