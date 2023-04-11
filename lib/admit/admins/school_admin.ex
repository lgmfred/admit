defmodule Admit.Admins.SchoolAdmin do
  @moduledoc """
  Documentation for Admit.Admins.SchoolAdmin
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "school_admins" do
    field :level, :integer, default: 1
    field :role, :string
    field :user_id, :id, references: :users
    field :school_id, :id, references: :schools

    timestamps()
  end

  @doc false
  def changeset(school_admin, attrs) do
    school_admin
    |> cast(attrs, [:role, :level, :user_id, :school_id])
    |> validate_required([:role, :level, :user_id, :school_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:school_id)
  end
end
