defmodule PhoenixServer.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_server,
    adapter: Ecto.Adapters.Postgres
end
