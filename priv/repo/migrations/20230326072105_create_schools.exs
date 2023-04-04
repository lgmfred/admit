defmodule Admit.Repo.Migrations.CreateSchools do
  use Ecto.Migration

  def change do
    create table(:schools) do
      add :name, :string
      add :address, :string
      add :telephone, :string
      add :email, :string
      add :level, :string

      timestamps()
    end

    create(unique_index(:schools, [:email]))
  end
end
