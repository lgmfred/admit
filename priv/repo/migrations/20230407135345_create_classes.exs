defmodule Admit.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :name, :string
      add :description, :text
      add :school_id, references(:schools, on_delete: :delete_all)

      timestamps()
    end

    create index(:classes, [:school_id])

    alter table(:schools) do
      add :classes, references(:classes, on_delete: :nothing)
    end
  end
end
