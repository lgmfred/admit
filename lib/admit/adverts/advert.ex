defmodule Admit.Adverts.Advert do
  @moduledoc """
  Advert schema module
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "adverts" do
    field :deadline, :date
    field :description, :string
    belongs_to :school, Admit.Schools.School
    belongs_to :class, Admit.Classes.Class
    has_many :applications, Admit.Applications.Application

    timestamps()
  end

  @doc false
  def changeset(advert, attrs) do
    advert
    |> cast(attrs, [:deadline, :description, :school_id, :class_id])
    |> validate_required([:deadline, :description, :school_id, :class_id])
    |> foreign_key_constraint(:school_id)
    |> foreign_key_constraint(:class_id)
  end
end
