defmodule AdmitWeb.AdvertLive.Show do
  use AdmitWeb, :live_view

  alias Admit.Adverts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:advert, Adverts.get_advert!(id))}
  end

  defp page_title(:show), do: "Show Advert"
  defp page_title(:edit), do: "Edit Advert"
end
