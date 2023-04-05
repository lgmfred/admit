defmodule Admit.Repo.Migrations.CreateSchoolAdmins do
  use Ecto.Migration

  def change do
    create table(:school_admins) do
      add :level, :integer, default: 1
      add :role, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :school_id, references(:schools, on_delete: :delete_all)

      timestamps()
    end

    create index(:school_admins, [:user_id])
    create index(:school_admins, [:school_id])

    alter table(:students) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    alter table(:users) do
      add :is_admin, :boolean, default: false
      add :students, references(:students, on_delete: :nothing)
    end
  end
end
