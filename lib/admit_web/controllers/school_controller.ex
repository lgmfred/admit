defmodule AdmitWeb.SchoolController do
  use AdmitWeb, :controller

  alias Admit.Schools
  alias Admit.Schools.School

  def index(conn, _params) do
    schools = Schools.list_schools()
    render(conn, "index.html", schools: schools)
  end

  def new(conn, _params) do
    changeset = Schools.change_school(%School{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"school" => school_params}) do
    current_user = conn.assigns[:current_user]

    case Schools.create_school(school_params, current_user) do
      {:ok, school} ->
        conn
        |> put_flash(:info, "School created successfully.")
        |> redirect(to: Routes.school_path(conn, :show, school))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    school = Schools.get_school!(id)
    render(conn, "show.html", school: school)
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    school = Schools.get_school!(id)
    changeset = Schools.change_school(school)
    render(conn, "edit.html", school: school, changeset: changeset)
  end

  def update(conn, %{"id" => id, "school" => school_params}) do
    school = Schools.get_school!(id)

    case Schools.update_school(school, school_params) do
      {:ok, school} ->
        conn
        |> put_flash(:info, "School updated successfully.")
        |> redirect(to: Routes.school_path(conn, :show, school))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", school: school, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    school = Schools.get_school!(id)
    {:ok, _school} = Schools.delete_school(school)

    conn
    |> put_flash(:info, "School deleted successfully.")
    |> redirect(to: Routes.school_path(conn, :index))
  end
end
