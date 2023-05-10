defmodule Admit.Applications do
  @moduledoc """
  The Applications context.
  """

  import Ecto.Query, warn: false
  alias Admit.Repo

  alias Admit.Applications.Application

  @doc """
  Returns the list of applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]

  """
  def list_applications do
    Repo.all(from a in Application, order_by: [asc: a.id])
  end

  @doc """
  Returns a list of applications matching the given `filter`

  Filter Example

  %{level: "primary", class: "P.5"}
  """
  def list_applications(filter) when is_map(filter) do
    from(Application)
    |> filter_by_application_status(filter)
    |> filter_by_class(filter)
    |> Repo.all()
  end

  def list_user_applications(user_id, filter \\ %{status: "", class: ""}) when is_map(filter) do
    from(a in Application,
      where: a.user_id == ^user_id,
      order_by: [asc: a.id]
    )
    |> filter_by_application_status(filter)
    |> filter_by_class(filter)
    |> Repo.all()
  end

  def list_school_applications(school_id, filter \\ %{status: "", class: ""})
      when is_map(filter) do
    from(a in Application,
      where: a.school_id == ^school_id,
      order_by: [asc: a.id]
    )
    |> filter_by_application_status(filter)
    |> filter_by_class(filter)
    |> Repo.all()
  end

  defp filter_by_application_status(query, %{status: ""}), do: query

  defp filter_by_application_status(query, %{status: status}) do
    where(query, status: ^status)
  end

  defp filter_by_class(query, %{class: ""}), do: query

  defp filter_by_class(query, %{class: class}) do
    # Join the advert and class associations with the application
    from(app in query,
      join: adv in assoc(app, :advert),
      join: cl in assoc(adv, :class),
      where: cl.name == ^class
    )
  end

  @doc """
  Gets a single application.

  Raises `Ecto.NoResultsError` if the Application does not exist.

  ## Examples

      iex> get_application!(123)
      %Application{}

      iex> get_application!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application!(id), do: Repo.get!(Application, id)

  @doc """
  Creates a application.

  ## Examples

      iex> create_application(%{field: value})
      {:ok, %Application{}}

      iex> create_application(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_application(attrs \\ %{}) do
    %Application{}
    |> Application.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a application.

  ## Examples

      iex> update_application(application, %{field: new_value})
      {:ok, %Application{}}

      iex> update_application(application, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_application(%Application{} = application, attrs) do
    application
    |> Application.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a application.

  ## Examples

      iex> delete_application(application)
      {:ok, %Application{}}

      iex> delete_application(application)
      {:error, %Ecto.Changeset{}}

  """
  def delete_application(%Application{} = application) do
    Repo.delete(application)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking application changes.

  ## Examples

      iex> change_application(application)
      %Ecto.Changeset{data: %Application{}}

  """
  def change_application(%Application{} = application, attrs \\ %{}) do
    Application.changeset(application, attrs)
  end
end
