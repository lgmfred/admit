defmodule AdmitWeb.CustomComponents do
  @moduledoc false

  use Phoenix.Component
  import Phoenix.HTML.Link
  alias AdmitWeb.Router.Helpers, as: Routes

  def page_header(assigns) do
    ~H"""
      <header class="z-10 my-0">
        <.main_header></.main_header>
        <.main_navigation></.main_navigation>
      </header>
    """
  end

  def main_header(assigns) do
    ~H"""
    <section class="shadow-lg my-0 mx-auto max-h-12 block bg-gray-400/75 text-center pb-0.5">
      <a href="#" class="font-mono"><img src="/images/admit.png" /></a>
      <%= if @current_user do %>
        <%= if @current_user.school_id do%>
          <label class="inline-table text-blue-600 text-center font-bold text-base uppercase"><%= Admit.Schools.get_school!(@current_user.school_id).name %></label>
        <% else %>
          <label class="inline-table text-blue-600 text-center font-bold text-base uppercase">ADMISSION MANAGEMENT SYSTEM</label>
        <% end %>
        <p class="inline-table text-sky-500"><%= @current_user.email %></p>
        <%= link "Log out", to: Routes.user_session_path(@conn, :delete), method: :delete, class: "inline-table"%>
      <% else %>
        <%= link "Register", to: Routes.user_registration_path(@conn, :new), class: "inline-table text-sky-500" %>
        <%= link "Log in", to: Routes.user_session_path(@conn, :new), class: "inline-table" %>
      <% end %>
    </section>
    """
  end

  def main_navigation(assigns) do
    ~H"""
    <section class="bg-gray-300 text-center py-0.5 shadow-2xl">
      <nav class="border-solid">
        <ul class="inline-flex px-4 rounded-2xl">
          <.nav_links href="/adverts"><i class="fa fa-fw fa-home"></i></.nav_links>
          <.nav_links href="/schools">Schools</.nav_links>
          <.nav_links href="/applications">Applications</.nav_links>
          <.nav_links href="/students">Student</.nav_links>
          <.nav_links href="/users/settings">Account</.nav_links>
          <.nav_links href="/icon_link"><i class="fa fa-fw fa-search"></i></.nav_links>
        </ul>
      </nav>
    </section>
    """
  end

  def nav_links(assigns) do
    ~H"""
    <li><a href={@href} class=""><%= render_slot(@inner_block)  %></a></li>
    """
  end
end
