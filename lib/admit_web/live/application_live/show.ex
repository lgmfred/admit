defmodule AdmitWeb.ApplicationLive.Show do
  use AdmitWeb, :live_view

  alias Admit.Accounts
  alias Admit.Adverts
  alias Admit.Applications
  alias AdmitWeb.ApplicationLive.Index

  @impl true
  def mount(params, session, socket) do
    if connected?(socket) do
      AdmitWeb.Endpoint.subscribe("applications")
    end

    user = Accounts.get_user_by_session_token(session["user_token"])
    students = Index.list_students(user.id)
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
     |> assign(:students, students)
     |> assign(:advert, advert)
     |> assign(:applications, Index.list_applications())}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:editing, true)
     |> assign(:status_options, Index.status_options())
     |> assign(:application, Applications.get_application!(id))}
  end

  defp page_title(:show), do: "Show Application"
  defp page_title(:edit), do: "Edit Application"
end
