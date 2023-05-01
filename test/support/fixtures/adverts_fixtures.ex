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
        deadline: Date.add(Date.utc_today(), 42),
        description: "some description"
      })
      |> Admit.Adverts.create_advert()

    advert
  end
end
