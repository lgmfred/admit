defmodule AdmitWeb.PageController do
  use AdmitWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.advert_index_path(conn, :index))
  end
end
