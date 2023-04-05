defmodule Admit.Admins do
  @moduledoc """
  The Admins context.
  """

  import Ecto.Query, warn: false
  alias Admit.Repo

  alias Admit.Admins.SchoolAdmin

  @doc """
  Returns the list of school_admins.

  ## Examples

      iex> list_school_admins()
      [%SchoolAdmin{}, ...]

  """
  def list_school_admins do
    Repo.all(SchoolAdmin)
  end

  @doc """
  Gets a single school_admin.

  Raises `Ecto.NoResultsError` if the School admin does not exist.

  ## Examples

      iex> get_school_admin!(123)
      %SchoolAdmin{}

      iex> get_school_admin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_school_admin!(id), do: Repo.get!(SchoolAdmin, id)

  @doc """
  Creates a school_admin.

  ## Examples

      iex> create_school_admin(%{field: value})
      {:ok, %SchoolAdmin{}}

      iex> create_school_admin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_school_admin(attrs \\ %{}) do
    %SchoolAdmin{}
    |> SchoolAdmin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a school_admin.

  ## Examples

      iex> update_school_admin(school_admin, %{field: new_value})
      {:ok, %SchoolAdmin{}}

      iex> update_school_admin(school_admin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_school_admin(%SchoolAdmin{} = school_admin, attrs) do
    school_admin
    |> SchoolAdmin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a school_admin.

  ## Examples

      iex> delete_school_admin(school_admin)
      {:ok, %SchoolAdmin{}}

      iex> delete_school_admin(school_admin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_school_admin(%SchoolAdmin{} = school_admin) do
    Repo.delete(school_admin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking school_admin changes.

  ## Examples

      iex> change_school_admin(school_admin)
      %Ecto.Changeset{data: %SchoolAdmin{}}

  """
  def change_school_admin(%SchoolAdmin{} = school_admin, attrs \\ %{}) do
    SchoolAdmin.changeset(school_admin, attrs)
  end
end
