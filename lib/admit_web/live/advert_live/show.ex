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

    adverts =
      Adverts.list_adverts()
      |> Repo.preload([:school, :class])

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:list_classes, Index.list_classes(user.school_id))
     |> assign(:adverts, adverts)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    advert =
      Adverts.get_advert!(id)
      |> Repo.preload([:school, :class])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:advert, advert)}
  end

  defp page_title(:show), do: "Show Advert"
  defp page_title(:edit), do: "Edit Advert"
end
