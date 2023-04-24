defmodule AdmitWeb.AdvertLive.FormComponent do
  use AdmitWeb, :live_component

  alias Admit.Adverts
  alias Admit.Repo

  @impl true
  def update(%{advert: advert} = assigns, socket) do
    changeset = Adverts.change_advert(advert)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"advert" => advert_params}, socket) do
    changeset =
      socket.assigns.advert
      |> Adverts.change_advert(advert_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"advert" => advert_params}, socket) do
    save_advert(socket, socket.assigns.action, advert_params)
  end

  defp save_advert(socket, :edit, advert_params) do
    case Adverts.update_advert(socket.assigns.advert, advert_params) do
      {:ok, advert} ->
        advert = Repo.preload(advert, [:school, :class])
        AdmitWeb.Endpoint.broadcast_from(self(), "adverts", "update_advert", advert)

        {:noreply,
         socket
         |> put_flash(:info, "Advert updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_advert(socket, :new, advert_params) do
    advert_params = Map.put(advert_params, "school_id", socket.assigns.user.school_id)

    case Adverts.create_advert(advert_params) do
      {:ok, advert} ->
        advert = Repo.preload(advert, [:school, :class])
        AdmitWeb.Endpoint.broadcast("adverts", "create_advert", advert)

        {:noreply,
         socket
         |> put_flash(:info, "Advert created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
