defmodule Admit.ApplicationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Admit.Applications` context.
  """

  @doc """
  Generate a application.
  """
  def application_fixture(attrs \\ %{}) do
    {:ok, application} =
      attrs
      |> Enum.into(%{
        documents: "some documents",
        status: "some status",
        submitted_on: ~N[2023-04-23 21:32:00]
      })
      |> Admit.Applications.create_application()

    application
  end
end
