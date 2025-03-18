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

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
