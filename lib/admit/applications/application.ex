defmodule Admit.Applications.Application do
  @moduledoc """
  Admit.Applications.Application schema module
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "applications" do
    field :documents, {:array, :string}, default: []
    field :status, :string
    belongs_to :advert, Admit.Adverts.Advert
    belongs_to :user, Admit.Accounts.User
    belongs_to :student, Admit.Students.Student
    belongs_to :school, Admit.Schools.School

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [
      :status,
      :documents,
      :advert_id,
      :user_id,
      :student_id,
      :school_id
    ])
    |> validate_required([
      :status,
      :documents,
      :advert_id,
      :user_id,
      :student_id,
      :school_id
    ])
    |> foreign_key_constraint(:advert_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:student_id)
    |> foreign_key_constraint(:school_id)
  end
end
