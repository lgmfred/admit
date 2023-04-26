defmodule AdmitWeb.ApplicationLive.Index do
  use AdmitWeb, :live_view

  alias Admit.Accounts
  alias Admit.Adverts
  alias Admit.Applications
  alias Admit.Applications.Application

  ## For redirection from show adverts
  @impl true
  def mount(params, session, socket) do
    if connected?(socket) do
      AdmitWeb.Endpoint.subscribe("applications")
    end

    user = Accounts.get_user_by_session_token(session["user_token"])
    advert_id = params["advert_id"]

    advert =
      if advert_id do
        Adverts.get_advert!(advert_id)
      else
        advert_id
      end

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:advert, advert)
     |> assign(:students, list_students(user.id))
     |> assign(:applications, list_applications())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Application")
    |> assign(:application, Applications.get_application!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Application")
    |> assign(:application, %Application{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Applications")
    |> assign(:application, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    application = Applications.get_application!(id)
    {:ok, _} = Applications.delete_application(application)

    AdmitWeb.Endpoint.broadcast_from(self(), "applications", "delete_application", %{
      application_id: id
    })

    filtered_applications =
      Enum.reject(socket.assigns.applications, fn each -> each.id == application.id end)

    {:noreply, assign(socket, :applications, filtered_applications)}
  end

  @impl true
  def handle_info(%{event: "create_application", payload: application}, socket) do
    {:noreply, assign(socket, :applications, [application | socket.assigns.applications])}
  end

  def handle_info(%{event: "update_application", payload: updated_application}, socket) do
    updated_applications =
      Enum.map(socket.assigns.applications, fn each ->
        if each.id == updated_application.id do
          updated_application
        else
          each
        end
      end)

    {:noreply, assign(socket, :applications, updated_applications)}
  end

  def handle_info(%{event: "delete_application", payload: payload}, socket) do
    application_id = String.to_integer(payload.application_id)

    filtered_applications =
      Enum.reject(socket.assigns.applications, fn each -> each.id == application_id end)

    {:noreply, assign(socket, :applications, filtered_applications)}
  end

  defp list_applications do
    Applications.list_applications()
  end

  def list_students(user_id) do
    Admit.Students.list_students(user_id)
    |> Enum.map(fn student -> {student.name, student.id} end)
  end
end
