defmodule Admit.Repo.Migrations.CreateAdverts do
  use Ecto.Migration

  def change do
    create table(:adverts) do
      add :published_on, :date
      add :deadline, :date
      add :description, :text
      add :school_id, references(:schools, on_delete: :nothing)
      add :class_id, references(:classes, on_delete: :nothing)

      timestamps()
    end

    create index(:adverts, [:school_id])
    create index(:adverts, [:class_id])

    alter table(:schools) do
      add :adverts, references(:adverts, on_delete: :nothing)
    end

    alter table(:classes) do
      add :adverts, references(:adverts, on_delete: :delete_all)
    end
  end
end
