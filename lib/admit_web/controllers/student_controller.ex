defmodule AdmitWeb.StudentController do
  use AdmitWeb, :controller

  alias Admit.Students
  alias Admit.Students.Student

  plug :require_user_owns_student when action in [:show, :edit, :update, :delete]

  def require_user_owns_student(conn, _opts) do
    student_id = String.to_integer(conn.path_params["id"])
    student = Students.get_student!(student_id)

    if conn.assigns[:current_user].id == student.user_id do
      conn
    else
      conn
      |> put_flash(:error, "You do not own this resource.")
      |> redirect(to: Routes.student_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    students = Students.list_students(conn.assigns[:current_user].id)
    render(conn, "index.html", students: students)
  end

  def new(conn, _params) do
    changeset = Students.change_student(%Student{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"student" => student_params}) do
    student_params = Map.put(student_params, "user_id", conn.assigns[:current_user].id)

    case Students.create_student(student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student created successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student = Students.get_student!(id)
    render(conn, "show.html", student: student)
  end

  def edit(conn, %{"id" => id}) do
    student = Students.get_student!(id)
    changeset = Students.change_student(student)
    render(conn, "edit.html", student: student, changeset: changeset)
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    student = Students.get_student!(id)

    case Students.update_student(student, student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student updated successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", student: student, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student = Students.get_student!(id)
    {:ok, _student} = Students.delete_student(student)

    conn
    |> put_flash(:info, "Student deleted successfully.")
    |> redirect(to: Routes.student_path(conn, :index))
  end
end
