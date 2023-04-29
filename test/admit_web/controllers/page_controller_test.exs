defmodule AdmitWeb.PageControllerTest do
  use AdmitWeb.ConnCase

  import Admit.AccountsFixtures

  test "GET /", %{conn: conn} do
    user = user_fixture()
    conn = log_in_user(conn, user)
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Oh Crap! I'm from"
  end
end
