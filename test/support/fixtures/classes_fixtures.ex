defmodule Admit.ClassesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Admit.Classes` context.
  """

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Admit.Classes.create_class()

    class
  end
end
