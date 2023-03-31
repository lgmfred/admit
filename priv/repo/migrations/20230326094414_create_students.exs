defmodule Admit.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students, primary_key: false) do
      add :id, :serial, primary_key: true
      add :name, :string
      add :email, :string
      add :birth_date, :date

      timestamps()
    end

    execute "select setval(pg_get_serial_sequence('students', 'id'), 10005000)"
  end
end
