defmodule AdmitWeb.CustomComponents do
  @moduledoc false
  use Phoenix.Component

  def nav_links(assigns) do
    ~H"""
    <li><a href={@href} class=""><%= render_slot(@inner_block)  %></a></li>
    """
  end
end
