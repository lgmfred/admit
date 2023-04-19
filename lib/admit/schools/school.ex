defmodule Admit.Schools.School do
  @moduledoc """
  Schools table schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "schools" do
    field :name, :string
    field :address, :string
    field :email, :string
    field :telephone, :string
    field :level, :string
    has_many :admins, Admit.Accounts.User, on_replace: :delete
    has_many :classes, Admit.Classes.Class
    has_many :adverts, Admit.Adverts.Advert

    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :address, :telephone, :email, :level])
    |> validate_required([:name, :address, :telephone, :email, :level])
  end
end
