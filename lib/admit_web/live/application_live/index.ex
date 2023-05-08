defmodule AdmitWeb.ApplicationLive.Index do
  use AdmitWeb, :live_view

  alias Admit.Accounts
  alias Admit.Adverts
  alias Admit.Applications
  alias Admit.Applications.Application
  alias Admit.Repo

  ## For redirection from show adverts
  @impl true
  def mount(params, session, socket) do
    if connected?(socket) do
      AdmitWeb.Endpoint.subscribe("applications")
    end

    user = Accounts.get_user_by_session_token(session["user_token"])
    advert = get_advert(params)
    applications = list_applications(user)
    filter = %{status: "", class: ""}
    classes = get_classes(user)
    status = status_options()

    {:ok,
     socket
     |> assign(
       user: user,
       advert: advert,
       classes: classes,
       applications: applications,
       status: status,
       filter: filter
     )
     |> assign(:students, list_students(user.id))
     |> allow_upload(:documents,
       accept: ~w(.jpg .jpeg .png .pdf),
       max_entries: 3,
       max_file_size: 10_000_000
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Application")
    |> assign(:editing, true)
    |> assign(:application, Applications.get_application!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Application")
    |> assign(:editing, false)
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

  def handle_event("filter", %{"status" => status, "class" => class}, socket) do
    filter = %{status: status, class: class}
    applications = list_applications(socket.assigns.user, filter)
    {:noreply, assign(socket, applications: applications, filter: filter)}
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

  def list_applications(user, filter \\ %{status: "", class: ""}) do
    case user do
      %{school_id: nil} -> Applications.list_user_applications(user.id, filter)
      %{school_id: school_id} -> Applications.list_school_applications(school_id, filter)
      _ -> []
    end
    |> Repo.preload([:student, :school, advert: [:class]])
  end

  def get_advert(params) do
    case params["advert_id"] do
      nil -> nil
      advert_id -> Adverts.get_advert!(advert_id)
    end
  end

  def get_classes(user) do
    classes =
      list_applications(user)
      |> Enum.map(fn app -> {app.advert.class.name, app.advert.class.name} end)
      |> Enum.uniq()
      |> Enum.sort()

    [{:"Select Class", ""} | classes]
  end

  def list_students(user_id) do
    Admit.Students.list_students(user_id)
    |> Enum.map(fn student -> {student.name, student.id} end)
  end

  def status_options do
    [
      "Select Status": nil,
      Submitted: "submitted",
      Review: "review",
      Interview: "interview",
      Accepted: "accepted",
      Rejected: "rejected"
    ]
  end
end
