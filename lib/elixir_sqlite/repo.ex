defmodule ElixirSqlite.Repo do
  use Ecto.Repo,
    otp_app: :elixir_sqlite,
    adapter: Ecto.Adapters.SQLite3
end
