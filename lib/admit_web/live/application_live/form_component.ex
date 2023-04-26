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
    submitted_on = DateTime.utc_now() |> DateTime.to_naive()
    default_status = "submitted"

    application_params =
      application_params
      |> Map.put("submitted_on", submitted_on)
      |> Map.put("status", default_status)
      |> Map.put("user_id", socket.assigns.user.id)
      |> Map.put("advert_id", socket.assigns.advert.id)
      |> Map.put("school_id", socket.assigns.advert.school_id)

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
