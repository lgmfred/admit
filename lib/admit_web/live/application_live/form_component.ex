defmodule AdmitWeb.ApplicationLive.FormComponent do
  use AdmitWeb, :live_component

  alias Admit.Applications

  @impl true
  def update(%{application: application} = assigns, socket) do
    changeset = Applications.change_application(application)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"application" => application_params}, socket) do
    changeset =
      socket.assigns.application
      |> Applications.change_application(application_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"application" => application_params}, socket) do
    documents =
      consume_uploaded_entries(socket, :documents, fn meta, entry ->
        dest = Path.join(["priv", "static", "uploads", "#{entry.uuid}-#{entry.client_name}"])
        File.cp!(meta.path, dest)
        url_path = Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
        {:ok, url_path}
      end)

    application_params = Map.put(application_params, "documents", documents)
    save_application(socket, socket.assigns.action, application_params)
  end

  defp save_application(socket, :edit, application_params) do
    case Applications.update_application(socket.assigns.application, application_params) do
      {:ok, application} ->
        AdmitWeb.Endpoint.broadcast("applications", "update_application", application)

        {:noreply,
         socket
         |> put_flash(:info, "Application updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_application(socket, :new, application_params) do
    application_params =
      application_params
      |> Map.put("user_id", socket.assigns.user.id)
      |> Map.put("advert_id", socket.assigns.advert.id)
      |> Map.put("school_id", socket.assigns.advert.school_id)
      |> Map.put("status", "submitted")

    case Applications.create_application(application_params) do
      {:ok, application} ->
        AdmitWeb.Endpoint.broadcast("applications", "create_application", application)

        {:noreply,
         socket
         |> put_flash(:info, "Application created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
