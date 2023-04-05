defmodule AdmitWeb.SchoolAdminController do
  use AdmitWeb, :controller

  alias Admit.Admins
  alias Admit.Admins.SchoolAdmin

  def index(conn, _params) do
    school_admins = Admins.list_school_admins()
    render(conn, "index.html", school_admins: school_admins)
  end

  def new(conn, _params) do
    changeset = Admins.change_school_admin(%SchoolAdmin{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"school_admin" => school_admin_params}) do
    case Admins.create_school_admin(school_admin_params) do
      {:ok, school_admin} ->
        conn
        |> put_flash(:info, "School admin created successfully.")
        |> redirect(to: Routes.school_admin_path(conn, :show, school_admin))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    school_admin = Admins.get_school_admin!(id)
    render(conn, "show.html", school_admin: school_admin)
  end

  def edit(conn, %{"id" => id}) do
    school_admin = Admins.get_school_admin!(id)
    changeset = Admins.change_school_admin(school_admin)
    render(conn, "edit.html", school_admin: school_admin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "school_admin" => school_admin_params}) do
    school_admin = Admins.get_school_admin!(id)

    case Admins.update_school_admin(school_admin, school_admin_params) do
      {:ok, school_admin} ->
        conn
        |> put_flash(:info, "School admin updated successfully.")
        |> redirect(to: Routes.school_admin_path(conn, :show, school_admin))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", school_admin: school_admin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    school_admin = Admins.get_school_admin!(id)
    {:ok, _school_admin} = Admins.delete_school_admin(school_admin)

    conn
    |> put_flash(:info, "School admin deleted successfully.")
    |> redirect(to: Routes.school_admin_path(conn, :index))
  end
end
