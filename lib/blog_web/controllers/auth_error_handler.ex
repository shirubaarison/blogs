defmodule BlogWeb.AuthErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  @behaviour Guardian.Plug.ErrorHandler

  def auth_error(conn, {error, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: to_string(error)})
    |> halt()
  end
end
