defmodule AdmitWeb.PageControllerTest do
  use AdmitWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Oh Crap! I'm from"
  end
end
