defmodule Admit.Repo do
  use Ecto.Repo,
    otp_app: :admit,
    adapter: Ecto.Adapters.Postgres
end
