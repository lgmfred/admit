defmodule AdmitWeb.PageController do
  use AdmitWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
