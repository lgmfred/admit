defmodule AdmitWeb.SchoolControllerTest do
  use AdmitWeb.ConnCase

  import Admit.SchoolsFixtures
  import Admit.AccountsFixtures

  @create_attrs %{
    address: "some address",
    email: "some email",
    level: "some level",
    name: "some name",
    telephone: "some telephone"
  }
  @update_attrs %{
    address: "some updated address",
    email: "some updated email",
    level: "some updated level",
    name: "some updated name",
    telephone: "some updated telephone"
  }
  @invalid_attrs %{
    address: nil,
    email: nil,
    level: nil,
    name: nil,
    telephone: nil
  }

  describe "index" do
    test "lists all schools", %{conn: conn} do
      conn = get(conn, Routes.school_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Schools"
    end
  end

  describe "new school" do
    test "renders form", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = get(conn, Routes.school_path(conn, :new))
      assert html_response(conn, 200) =~ "New School"
    end
  end

  describe "create school" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = post(conn, Routes.school_path(conn, :create), school: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.school_path(conn, :show, id)

      conn = get(conn, Routes.school_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show School"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = post(conn, Routes.school_path(conn, :create), school: @invalid_attrs)
      assert html_response(conn, 200) =~ "New School"
    end
  end

  describe "edit school" do
    setup [:create_school]

    test "renders form for editing chosen school", %{conn: conn, school: school} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = get(conn, Routes.school_path(conn, :edit, school))
      assert html_response(conn, 200) =~ "Edit School"
    end
  end

  describe "update school" do
    setup [:create_school]

    test "redirects when data is valid", %{conn: conn, school: school} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = put(conn, Routes.school_path(conn, :update, school), school: @update_attrs)
      assert redirected_to(conn) == Routes.school_path(conn, :show, school)

      conn = get(conn, Routes.school_path(conn, :show, school))
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, school: school} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = put(conn, Routes.school_path(conn, :update, school), school: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit School"
    end
  end

  describe "delete school" do
    setup [:create_school]

    test "deletes chosen school", %{conn: conn, school: school} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = delete(conn, Routes.school_path(conn, :delete, school))
      assert redirected_to(conn) == Routes.school_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.school_path(conn, :show, school))
      end
    end
  end

  defp create_school(_) do
    school = school_fixture()
    %{school: school}
  end
end
