defmodule Admit.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :submitted_on, :naive_datetime
      add :status, :string
      add :documents, :string
      add :advert_id, references(:adverts, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :student_id, references(:students, on_delete: :nothing)
      add :school_id, references(:schools, on_delete: :nothing)

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
