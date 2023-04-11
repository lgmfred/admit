defmodule Admit.Classes.Class do
  @moduledoc """
  Class Schema module documentation
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :description, :string
    field :name, :string
    belongs_to :school, Admit.Schools.School

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :description, :school_id])
    |> validate_required([:name, :description, :school_id])
    |> foreign_key_constraint(:school_id)
  end
end
