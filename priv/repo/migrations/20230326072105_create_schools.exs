defmodule Admit.Repo.Migrations.CreateSchools do
  use Ecto.Migration

  def change do
    create table(:schools, primary_key: false) do
      add :id, :serial, primary_key: true
      add :name, :string
      add :address, :string
      add :telephone, :string
      add :email, :string
      add :level, :string

      timestamps()
    end

    execute "select setval(pg_get_serial_sequence('schools', 'id'), 1005000)"
  end
end
