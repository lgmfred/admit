defmodule AdmitWeb.ApplicationLive.Show do
  use AdmitWeb, :live_view

  alias Admit.Accounts
  alias Admit.Adverts
  alias Admit.Applications
  alias AdmitWeb.ApplicationLive.Index
  alias Admit.Repo

  @impl true
  def mount(params, session, socket) do
    if connected?(socket) do
      AdmitWeb.Endpoint.subscribe("applications")
    end

    user = Accounts.get_user_by_session_token(session["user_token"])
    students = Index.list_students(user.id)
    status = Index.status_options()

    {
      :ok,
      socket
      |> assign(user: user, status: status)
      |> assign(:students, students)
      |> allow_upload(:documents,
        accept: ~w(.jpg .jpeg .png .pdf),
        max_entries: 3,
        max_file_size: 1_000_000
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:editing, true)
     |> assign(:status_options, Index.status_options())
     |> assign(:application, get_application(id))}
  end

  defp page_title(:show), do: "Show Application"
  defp page_title(:edit), do: "Edit Application"

  defp get_application(id) do
    Applications.get_application!(id)
    |> Repo.preload([:student, :school, advert: [:class]])
  end
end
