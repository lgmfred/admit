defmodule Admit.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :name, :string
      add :description, :text
      add :school_id, references(:schools, on_delete: :nothing)

      timestamps()
    end

    create index(:classes, [:school_id])
  end
end
