defmodule AdmitWeb.PageControllerTest do
  use AdmitWeb.ConnCase

  import Admit.AccountsFixtures

  test "GET /", %{conn: conn} do
    user = user_fixture()
    conn = log_in_user(conn, user)
    conn = get(conn, "/")
    assert redirected_to(conn) == "/adverts"
  end
end
