defmodule Admit.StudentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Admit.Students` context.
  """

  @doc """
  Generate a student.
  """
  def student_fixture(attrs \\ %{}) do
    {:ok, student} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2023-03-25],
        email: "some email",
        name: "some name"
      })
      |> Admit.Students.create_student()

    student
  end
end
