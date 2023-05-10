defmodule AdmitWeb.AdvertLive.Show do
  use AdmitWeb, :live_view

  alias Admit.Accounts
  alias Admit.Adverts
  alias Admit.Repo
  alias AdmitWeb.AdvertLive.Index

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      AdmitWeb.Endpoint.subscribe("adverts")
    end

    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok, assign(socket, user: user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    advert =
      Adverts.get_advert!(id)
      |> Repo.preload([:school, :class])

    live_action = socket.assigns.live_action
    user = socket.assigns.user

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:advert, advert)
     |> assign(:classes, list_classes(live_action, user))}
  end

  defp page_title(:show), do: "Show Advert"
  defp page_title(:edit), do: "Edit Advert"

  defp list_classes(:show, user), do: Index.list_classes(user)
  defp list_classes(:edit, user), do: Index.school_classes(user)
end
