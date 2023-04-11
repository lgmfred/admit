defmodule AdmitWeb.SchoolAdminControllerTest do
  use AdmitWeb.ConnCase

  import Admit.AccountsFixtures
  import Admit.AdminsFixtures
  import Admit.SchoolsFixtures

  @create_attrs %{level: Enum.random(1..3), role: "some role"}
  @update_attrs %{level: Enum.random(1..3), role: "some updated role"}
  @invalid_attrs %{level: nil, role: nil}

  describe "index" do
    test "lists all school_admins", %{conn: conn} do
      conn = get(conn, Routes.school_admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing School admins"
    end
  end

  describe "new school_admin" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.school_admin_path(conn, :new))
      assert html_response(conn, 200) =~ "New School admin"
    end
  end

  describe "create school_admin" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()
      school = school_fixture()

      attrs =
        @create_attrs
        |> Map.put(:user_id, user.id)
        |> Map.put(:school_id, school.id)

      conn = post(conn, Routes.school_admin_path(conn, :create), school_admin: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.school_admin_path(conn, :show, id)

      conn = get(conn, Routes.school_admin_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show School admin"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.school_admin_path(conn, :create), school_admin: @invalid_attrs)
      assert html_response(conn, 200) =~ "New School admin"
    end
  end

  describe "edit school_admin" do
    test "renders form for editing chosen school_admin", %{conn: conn} do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)
      conn = get(conn, Routes.school_admin_path(conn, :edit, school_admin))
      assert html_response(conn, 200) =~ "Edit School admin"
    end
  end

  describe "update school_admin" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)

      conn =
        put(conn, Routes.school_admin_path(conn, :update, school_admin),
          school_admin: @update_attrs
        )

      assert redirected_to(conn) == Routes.school_admin_path(conn, :show, school_admin)

      conn = get(conn, Routes.school_admin_path(conn, :show, school_admin))
      assert html_response(conn, 200) =~ "some updated role"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)

      conn =
        put(conn, Routes.school_admin_path(conn, :update, school_admin),
          school_admin: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit School admin"
    end
  end

  describe "delete school_admin" do
    test "deletes chosen school_admin", %{conn: conn} do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)
      conn = delete(conn, Routes.school_admin_path(conn, :delete, school_admin))
      assert redirected_to(conn) == Routes.school_admin_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.school_admin_path(conn, :show, school_admin))
      end
    end
  end
end
