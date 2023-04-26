defmodule AdmitWeb.ApplicationLive.Show do
  use AdmitWeb, :live_view

  alias Admit.Accounts
  alias Admit.Adverts
  alias Admit.Applications

  @impl true
  def mount(params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
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
     |> assign(:advert, advert)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:application, Applications.get_application!(id))}
  end

  defp page_title(:show), do: "Show Application"
  defp page_title(:edit), do: "Edit Application"
end
