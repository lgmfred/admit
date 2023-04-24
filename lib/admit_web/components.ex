defmodule AdmitWeb.Components do
  @moduledoc false

  use Phoenix.Component

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
      <%!-- <%= render "_user_menu.html", assigns %> --%>
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
          <.nav_links href="/admission">Admission</.nav_links>
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
    <li><a href={@href} class="text-lg text-gray-800 px-4 py-1.5 font-extrabold hover:bg-gray-800 hover:text-white"><%= render_slot(@inner_block)  %></a></li>
    """
  end
end
