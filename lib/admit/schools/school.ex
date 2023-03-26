defmodule Admit.Schools.School do
  @moduledoc """
  Schools table schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "schools" do
    field :id, :integer, primary_key: true, read_after_writes: true
    field :name, :string
    field :address, :string
    field :email, :string
    field :telephone, :string
    field :level, :string

    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :address, :telephone, :email, :level])
    |> validate_required([:name, :address, :telephone, :email, :level])
  end
end
