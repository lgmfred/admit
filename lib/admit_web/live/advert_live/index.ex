defmodule AdmitWeb.AdvertLive.Index do
  @moduledoc """
  AdmitWeb.AdvertLive.Index module documentation
  """
  use AdmitWeb, :live_view

  alias Admit.Accounts
  alias Admit.Adverts
  alias Admit.Adverts.Advert
  alias Admit.Classes
  alias Admit.Repo

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      AdmitWeb.Endpoint.subscribe("adverts")
    end

    user = Accounts.get_user_by_session_token(session["user_token"])
    adverts = list_adverts(user)
    classes = list_classes(user)

    {:ok,
     socket
     |> assign(user: user, classes: classes, adverts: adverts)
     |> assign(filter: %{level: "", class: ""})}
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
    |> assign(:classes, school_classes(socket.assigns.user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Advert")
    |> assign(:advert, %Advert{})
    |> assign(:classes, school_classes(socket.assigns.user))
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
    adverts = list_adverts(socket.assigns.user, filter)
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

  def list_adverts(user, filter \\ %{level: "", class: ""}) do
    case user do
      %{school_id: nil} -> Adverts.list_adverts(filter)
      %{school_id: school_id} -> Adverts.list_school_adverts(school_id, filter)
      _ -> []
    end
    |> Repo.preload([:school, :class])
  end

  def school_classes(user) do
    case user do
      %{school_id: nil} ->
        [{"Select Class", nil}]

      %{school_id: school_id} ->
        classes =
          Classes.list_classes(school_id)
          |> Enum.map(fn class -> {class.name, class.id} end)
          |> Enum.uniq()
          |> Enum.sort()

        [{"Select Class", nil} | classes]
    end
  end

  def list_classes(user) do
    case user do
      %{school_id: nil} ->
        nursery = ["Select Class": "", Baby: "Baby", Middle: "Middle", Top: "Top"]
        primary = Enum.map(1..7, fn x -> {"P.#{x}", "P.#{x}"} end)
        secondary = Enum.map(1..6, fn x -> {"S.#{x}", "S.#{x}"} end)

        nursery ++ primary ++ secondary

      %{school_id: school_id} ->
        classes =
          Classes.list_classes(school_id)
          |> Enum.map(fn class -> {class.name, class.name} end)
          |> Enum.uniq()
          |> Enum.sort()

        [{"Select Class", nil} | classes]

      _ ->
        []
    end
  end
end
