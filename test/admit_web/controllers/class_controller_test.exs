defmodule AdmitWeb.ClassControllerTest do
  use AdmitWeb.ConnCase

  import Admit.ClassesFixtures
  import Admit.SchoolsFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  describe "index" do
    test "lists all classes", %{conn: conn} do
      conn = get(conn, Routes.class_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Classes"
    end
  end

  describe "new class" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.class_path(conn, :new))
      assert html_response(conn, 200) =~ "New Class"
    end
  end

  describe "create class" do
    test "redirects to show when data is valid", %{conn: conn} do
      school = school_fixture()

      attrs =
        @create_attrs
        |> Map.put(:school_id, school.id)

      conn = post(conn, Routes.class_path(conn, :create), class: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.class_path(conn, :show, id)

      conn = get(conn, Routes.class_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Class"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.class_path(conn, :create), class: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Class"
    end
  end

  describe "edit class" do
    test "renders form for editing chosen class", %{conn: conn} do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      conn = get(conn, Routes.class_path(conn, :edit, class))
      assert html_response(conn, 200) =~ "Edit Class"
    end
  end

  describe "update class" do
    test "redirects when data is valid", %{conn: conn} do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      conn = put(conn, Routes.class_path(conn, :update, class), class: @update_attrs)
      assert redirected_to(conn) == Routes.class_path(conn, :show, class)

      conn = get(conn, Routes.class_path(conn, :show, class))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      conn = put(conn, Routes.class_path(conn, :update, class), class: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Class"
    end
  end

  describe "delete class" do
    test "deletes chosen class", %{conn: conn} do
      school = school_fixture()
      class = class_fixture(school_id: school.id)
      conn = delete(conn, Routes.class_path(conn, :delete, class))
      assert redirected_to(conn) == Routes.class_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.class_path(conn, :show, class))
      end
    end
  end
end
