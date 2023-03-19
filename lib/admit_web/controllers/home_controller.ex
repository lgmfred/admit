defmodule AdmitWeb.HomeController do
  use AdmitWeb, :controller

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
