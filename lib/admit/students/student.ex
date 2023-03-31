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

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:name, :email, :birth_date])
    |> validate_required([:name, :email, :birth_date])
  end
end
