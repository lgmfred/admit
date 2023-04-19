defmodule Admit.AdvertsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Admit.Adverts` context.
  """

  @doc """
  Generate a advert.
  """
  def advert_fixture(attrs \\ %{}) do
    {:ok, advert} =
      attrs
      |> Enum.into(%{
        deadline: ~D[2023-04-16],
        description: "some description",
        published_on: ~D[2023-04-16]
      })
      |> Admit.Adverts.create_advert()

    advert
  end
end
