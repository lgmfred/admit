defmodule Admit.Students.Student do
  @moduledoc """
  Students Schema module
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do
    field :birth_date, :date
    field :email, :string
    field :name, :string
    belongs_to :user, Admit.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:name, :email, :birth_date, :user_id])
    |> validate_required([:name, :email, :birth_date])
    |> foreign_key_constraint(:user_id)
  end
end
