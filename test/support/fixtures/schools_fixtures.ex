defmodule Admit.SchoolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Admit.Schools` context.
  """

  @doc """
  Generate a school.
  """
  def school_fixture(attrs \\ %{}) do
    {:ok, school} =
      attrs
      |> Enum.into(%{
        address: "some address",
        email: "school-#{System.unique_integer()}@email.com",
        level: "some level",
        name: "some name",
        telephone: "some telephone"
      })
      |> Admit.Schools.create_school()

    school
  end
end
