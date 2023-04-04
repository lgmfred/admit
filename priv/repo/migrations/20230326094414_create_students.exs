defmodule Admit.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :name, :string
      add :email, :string
      add :birth_date, :date

      timestamps()
    end

    create(unique_index(:students, [:email]))
  end
end
