defmodule Admit.Applications.Application do
  @moduledoc """
  Admit.Applications.Application schema module
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "applications" do
    field :documents, :string
    field :status, :string
    field :submitted_on, :naive_datetime
    belongs_to :advert, Admit.Adverts.Advert
    belongs_to :user, Admit.Accounts.User
    belongs_to :student, Admit.Students.Student
    belongs_to :school, Admit.Schools.School

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:submitted_on, :status, :documents])
    |> validate_required([:submitted_on, :status, :documents])
  end
end
