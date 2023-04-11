defmodule Admit.Repo.Migrations.AddAdminUserFieldsToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :school_id, references(:schools, on_delete: :nilify_all)
    end

    alter table(:schools) do
      add :admins, references(:users, on_delete: :delete_all)
    end
  end
end
