defmodule Admit.Adverts.Advert do
  @moduledoc """
  Advert schema module
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "adverts" do
    field :deadline, :date
    field :description, :string
    field :published_on, :date
    belongs_to :school, Admit.Schools.School
    belongs_to :class, Admit.Classes.Class

    timestamps()
  end

  @doc false
  def changeset(advert, attrs) do
    advert
    |> cast(attrs, [:published_on, :deadline, :description, :school_id, :class_id])
    |> validate_required([:published_on, :deadline, :description, :school_id, :class_id])
    |> foreign_key_constraint(:school_id)
    |> foreign_key_constraint(:class_id)
  end
end
