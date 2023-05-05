defmodule Admit.Adverts do
  @moduledoc """
  The Adverts context.
  """

  import Ecto.Query, warn: false
  alias Admit.Repo

  alias Admit.Adverts.Advert

  @doc """
  Returns the list of adverts.

  ## Examples

      iex> list_adverts()
      [%Advert{}, ...]

  """
  def list_adverts do
    Repo.all(from a in Advert, order_by: [asc: a.id])
  end

  @doc """
  Returns a list of adverts matching the given `filter`

  Filter Example: %{level: "primary", class: "P.5"}
  """
  def list_adverts(filter) when is_map(filter) do
    from(Advert)
    |> filter_by_school_level(filter)
    |> filter_by_class(filter)
    |> Repo.all()
  end

  def list_school_adverts(school_id, filter \\ %{level: "", class: ""})
      when is_map(filter) do
    from(a in Advert,
      where: a.school_id == ^school_id,
      order_by: [asc: a.id]
    )
    |> filter_by_school_level(filter)
    |> filter_by_class(filter)
    |> Repo.all()
  end

  defp filter_by_school_level(query, %{level: ""}), do: query

  defp filter_by_school_level(query, %{level: level}) do
    # Join the school association with the advert association
    from(a in query,
      join: s in assoc(a, :school),
      where: s.level == ^level
    )
  end

  defp filter_by_class(query, %{class: ""}), do: query

  defp filter_by_class(query, %{class: class}) do
    # Join the class association with the advert association
    from(a in query,
      join: c in assoc(a, :class),
      where: c.name == ^class
    )
  end

  @doc """
  Gets a single advert.

  Raises `Ecto.NoResultsError` if the Advert does not exist.

  ## Examples

      iex> get_advert!(123)
      %Advert{}

      iex> get_advert!(456)
      ** (Ecto.NoResultsError)

  """
  def get_advert!(id), do: Repo.get!(Advert, id)

  @doc """
  Creates a advert.

  ## Examples

      iex> create_advert(%{field: value})
      {:ok, %Advert{}}

      iex> create_advert(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_advert(attrs \\ %{}) do
    %Advert{}
    |> Advert.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a advert.

  ## Examples

      iex> update_advert(advert, %{field: new_value})
      {:ok, %Advert{}}

      iex> update_advert(advert, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_advert(%Advert{} = advert, attrs) do
    advert
    |> Advert.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a advert.

  ## Examples

      iex> delete_advert(advert)
      {:ok, %Advert{}}

      iex> delete_advert(advert)
      {:error, %Ecto.Changeset{}}

  """
  def delete_advert(%Advert{} = advert) do
    Repo.delete(advert)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking advert changes.

  ## Examples

      iex> change_advert(advert)
      %Ecto.Changeset{data: %Advert{}}

  """
  def change_advert(%Advert{} = advert, attrs \\ %{}) do
    Advert.changeset(advert, attrs)
  end
end
