defmodule AdmitWeb.Components do
  @moduledoc false

  use Phoenix.Component

  # attr :item, :string, required: true
  # attr :href, :string, required: true

  def nav_links(assigns) do
    ~H"""
    <%!-- <a href={@href} class="text-gray-800 px-2 font-extrabold"><%= render_slot(@inner_block) %></a> --%>
    <li><a href={@href} class="text-lg text-gray-800 px-4 py-1.5 font-extrabold hover:bg-gray-800 hover:text-white"><%= render_slot(@inner_block)  %></a></li>
    """
  end
end
