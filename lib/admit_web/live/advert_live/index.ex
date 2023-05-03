defmodule AdmitWeb.AdvertLive.Index do
  @moduledoc """
  AdmitWeb.AdvertLive.Index module documentation
  """
  use AdmitWeb, :live_view

  alias Admit.Accounts
  alias Admit.Adverts
  alias Admit.Adverts.Advert
  alias Admit.Repo

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      AdmitWeb.Endpoint.subscribe("adverts")
    end

    user = Accounts.get_user_by_session_token(session["user_token"])

    adverts = list_adverts()

    list_classes =
      if user.school_id do
        list_classes(user.school_id)
      else
        []
      end

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:list_classes, list_classes)
     |> assign(filter: %{level: "", class: ""})
     |> assign(:adverts, adverts)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    advert =
      Adverts.get_advert!(id)
      |> Repo.preload([:school, :class])

    socket
    |> assign(:page_title, "Edit Advert")
    |> assign(:advert, advert)
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

    AdmitWeb.Endpoint.broadcast_from(self(), "adverts", "delete_advert", %{advert_id: id})
    filtered_adverts = Enum.reject(socket.assigns.adverts, fn each -> each.id == advert.id end)

    {:noreply, assign(socket, :adverts, filtered_adverts)}
  end

  def handle_event("filter", %{"level" => level, "class" => class}, socket) do
    filter = %{level: level, class: class}
    adverts = list_adverts(filter)
    {:noreply, assign(socket, adverts: adverts, filter: filter)}
  end

  @impl true
  def handle_info(%{event: "create_advert", payload: advert}, socket) do
    {:noreply, assign(socket, :adverts, [advert | socket.assigns.adverts])}
  end

  def handle_info(%{event: "update_advert", payload: updated_advert}, socket) do
    updated_adverts =
      Enum.map(socket.assigns.adverts, fn each ->
        if each.id == updated_advert.id do
          updated_advert
        else
          each
        end
      end)

    {:noreply, assign(socket, :adverts, updated_adverts)}
  end

  def handle_info(%{event: "delete_advert", payload: payload}, socket) do
    advert_id = String.to_integer(payload.advert_id)
    filtered_adverts = Enum.reject(socket.assigns.adverts, fn each -> each.id == advert_id end)

    {:noreply, assign(socket, :adverts, filtered_adverts)}
  end

  defp list_adverts do
    Adverts.list_adverts()
    |> Repo.preload([:school, :class])
  end

  defp list_adverts(filter) do
    Adverts.list_adverts(filter)
    |> Repo.preload([:school, :class])
  end

  def list_classes(school_id) do
    Admit.Classes.list_classes(school_id)
    |> Enum.map(fn class -> {class.name, class.id} end)
  end
end
