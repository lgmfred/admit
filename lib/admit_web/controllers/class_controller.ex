defmodule AdmitWeb.ClassController do
  use AdmitWeb, :controller

  alias Admit.Classes
  alias Admit.Classes.Class

  plug :require_user_is_the_school_admin when action in [:edit, :update, :delete]

  def require_user_is_the_school_admin(conn, _opts) do
    class_id = String.to_integer(conn.path_params["id"])
    class = Classes.get_class!(class_id)

    if conn.assigns[:current_user].school_id == class.school_id do
      conn
    else
      conn
      |> put_flash(:error, "You do not own this resource.")
      |> redirect(to: Routes.class_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    user = conn.assigns[:current_user]

    classes =
      case user do
        %{school_id: school_id} when is_integer(school_id) ->
          Classes.list_classes(school_id)

        _ ->
          []
      end

    render(conn, "index.html", classes: classes)
  end

  def new(conn, _params) do
    changeset = Classes.change_class(%Class{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"class" => class_params}) do
    school_id = conn.assigns[:current_user].school_id
    class_params = Map.put(class_params, "school_id", school_id)

    case Classes.create_class(class_params) do
      {:ok, class} ->
        conn
        |> put_flash(:info, "Class created successfully.")
        |> redirect(to: Routes.class_path(conn, :show, class))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    class = Classes.get_class!(id)
    render(conn, "show.html", class: class)
  end

  def edit(conn, %{"id" => id}) do
    class = Classes.get_class!(id)
    changeset = Classes.change_class(class)
    render(conn, "edit.html", class: class, changeset: changeset)
  end

  def update(conn, %{"id" => id, "class" => class_params}) do
    class = Classes.get_class!(id)

    case Classes.update_class(class, class_params) do
      {:ok, class} ->
        conn
        |> put_flash(:info, "Class updated successfully.")
        |> redirect(to: Routes.class_path(conn, :show, class))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", class: class, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    class = Classes.get_class!(id)
    {:ok, _class} = Classes.delete_class(class)

    conn
    |> put_flash(:info, "Class deleted successfully.")
    |> redirect(to: Routes.class_path(conn, :index))
  end
end
