defmodule AdmitWeb.AdvertLive.Index do
  use AdmitWeb, :live_view

  alias Hex.Repo
  alias Admit.Adverts
  alias Admit.Adverts.Advert
  alias Admit.Accounts

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    adverts =
      list_adverts()
      |> Admit.Repo.preload([:school, :class])

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:list_classes, list_classes(user.school_id))
     |> assign(:adverts, adverts)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Advert")
    |> assign(:advert, Adverts.get_advert!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Advert")
    |> assign(:advert, %Advert{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Adverts")
    |> assign(:advert, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    advert = Adverts.get_advert!(id)
    {:ok, _} = Adverts.delete_advert(advert)

    {:noreply, assign(socket, :adverts, list_adverts())}
  end

  defp list_adverts do
    Adverts.list_adverts()
  end

  def list_classes(school_id) do
    Admit.Classes.list_classes(school_id)
    |> Enum.map(fn class -> {class.name, class.id} end)
  end
end
