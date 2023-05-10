defmodule Admit.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :status, :string, null: false
      add :documents, {:array, :string}, null: false, default: []
      add :advert_id, references(:adverts, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :student_id, references(:students, on_delete: :nothing), null: false
      add :school_id, references(:schools, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:applications, [:advert_id])
    create index(:applications, [:user_id])
    create index(:applications, [:student_id])
    create index(:applications, [:school_id])

    alter table(:adverts) do
      add :applications, references(:applications, on_delete: :nothing)
    end

    alter table(:users) do
      add :applications, references(:applications, on_delete: :nothing)
    end

    alter table(:students) do
      add :applications, references(:applications, on_delete: :nothing)
    end

    alter table(:schools) do
      add :applications, references(:applications, on_delete: :nothing)
    end
  end
end
