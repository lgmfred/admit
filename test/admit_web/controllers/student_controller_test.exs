defmodule AdmitWeb.StudentControllerTest do
  use AdmitWeb.ConnCase

  import Admit.StudentsFixtures
  import Admit.AccountsFixtures

  @create_attrs %{birth_date: ~D[2023-03-25], email: "some email", name: "some name"}
  @update_attrs %{
    birth_date: ~D[2023-03-26],
    email: "some updated email",
    name: "some updated name"
  }
  @invalid_attrs %{birth_date: nil, email: nil, name: nil}

  describe "index" do
    test "lists all students", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = get(conn, Routes.student_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Students"
    end
  end

  describe "new student" do
    test "renders form", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = get(conn, Routes.student_path(conn, :new))
      assert html_response(conn, 200) =~ "New Student"
    end
  end

  describe "create student" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = post(conn, Routes.student_path(conn, :create), student: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.student_path(conn, :show, id)

      conn = get(conn, Routes.student_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Student"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = post(conn, Routes.student_path(conn, :create), student: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Student"
    end
  end

  describe "edit student" do
    test "renders form for editing chosen student", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      student = student_fixture(user_id: user.id)
      conn = get(conn, Routes.student_path(conn, :edit, student))
      assert html_response(conn, 200) =~ "Edit Student"
    end
  end

  describe "update student" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      student = student_fixture(user_id: user.id)
      conn = put(conn, Routes.student_path(conn, :update, student), student: @update_attrs)
      assert redirected_to(conn) == Routes.student_path(conn, :show, student)

      conn = get(conn, Routes.student_path(conn, :show, student))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      student = student_fixture(user_id: user.id)
      conn = log_in_user(conn, user)
      conn = put(conn, Routes.student_path(conn, :update, student), student: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Student"
    end
  end

  describe "delete student" do
    test "deletes chosen student", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      student = student_fixture(user_id: user.id)
      conn = delete(conn, Routes.student_path(conn, :delete, student))
      assert redirected_to(conn) == Routes.student_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.student_path(conn, :show, student))
      end
    end
  end
end
