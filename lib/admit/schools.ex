defmodule Admit.Schools do
  @moduledoc """
  The Schools context.
  """

  import Ecto.Query, warn: false
  alias Admit.Repo

  alias Admit.Accounts
  alias Admit.Schools.School

  @doc """
  Returns the list of schools.

  ## Examples

      iex> list_schools()
      [%School{}, ...]

  """
  def list_schools do
    Repo.all(School)
  end

  @doc """
  Gets a single school.

  Raises `Ecto.NoResultsError` if the School does not exist.

  ## Examples

      iex> get_school!(123)
      %School{}

      iex> get_school!(456)
      ** (Ecto.NoResultsError)

  """
  def get_school!(id), do: Repo.get!(School, id)

  @doc """
  Creates a school.

  ## Examples

      iex> create_school(%{field: value})
      {:ok, %School{}}

      iex> create_school(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_school(attrs \\ %{}) do
    %School{}
    |> School.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a school with an admin.

  ## Examples

      iex> user = user_fixture()
      iex> create_school(%{field: value}, user)
      {:ok, %School{}}

      iex> user = user_fixture()
      iex> create_school(%{field: bad_value}, user)
      {:error, %Ecto.Changeset{}}

  """
  def create_school(attrs, admin_user) do
    %School{}
    |> School.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:admins, [admin_user])
    |> Repo.insert()
  end

  @doc """
  Updates a school.

  ## Examples

      iex> update_school(school, %{field: new_value})
      {:ok, %School{}}

      iex> update_school(school, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_school(%School{} = school, attrs) do
    school
    |> School.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Add new admin user to school
  """
  def add_admin(school_id, email) do
    school =
      get_school!(school_id)
      |> Repo.preload([:admins])

    user =
      Accounts.get_user_by_email(email)
      |> Repo.preload([:school])

    school
    |> School.changeset(%{})
    |> Ecto.Changeset.put_assoc(:admins, [user | school.admins])
    |> Repo.update()
  end

  @doc """
  Deletes a school.

  ## Examples

      iex> delete_school(school)
      {:ok, %School{}}

      iex> delete_school(school)
      {:error, %Ecto.Changeset{}}

  """
  def delete_school(%School{} = school) do
    Repo.delete(school)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking school changes.

  ## Examples

      iex> change_school(school)
      %Ecto.Changeset{data: %School{}}

  """
  def change_school(%School{} = school, attrs \\ %{}) do
    School.changeset(school, attrs)
  end
end
