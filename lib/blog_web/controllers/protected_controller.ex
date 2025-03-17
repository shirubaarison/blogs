defmodule BlogWeb.ProtectedController do
  use BlogWeb, :controller

  def hello(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{
      hello: "world!"
    })
  end
end
