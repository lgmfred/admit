defmodule Admit.AdminsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Admit.Admins` context.
  """

  @doc """
  Generate a school_admin.
  """
  def school_admin_fixture(attrs \\ %{}) do
    {:ok, school_admin} =
      attrs
      |> Enum.into(%{
        level: Enum.random(1..3),
        role: "some role"
      })
      |> Admit.Admins.create_school_admin()

    school_admin
  end
end
