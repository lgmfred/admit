defmodule AdmitWeb.ApplicationLiveTest do
  use AdmitWeb.ConnCase

  import Phoenix.LiveViewTest
  import Admit.ApplicationsFixtures
  import Admit.AccountsFixtures

  @create_attrs %{
    documents: "some documents",
    status: "some status",
    submitted_on: %{day: 23, hour: 21, minute: 32, month: 4, year: 2023}
  }
  @update_attrs %{
    documents: "some updated documents",
    status: "some updated status",
    submitted_on: %{day: 24, hour: 21, minute: 32, month: 4, year: 2023}
  }
  @invalid_attrs %{
    documents: nil,
    status: nil,
    submitted_on: %{day: 30, hour: 21, minute: 32, month: 2, year: 2023}
  }

  defp create_application(_) do
    application = application_fixture()
    %{application: application}
  end

  describe "Index" do
    test "lists all applications", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      application = application_fixture()

      {:ok, _index_live, html} = live(conn, Routes.application_index_path(conn, :index))

      assert html =~ "Listing Applications"
      assert html =~ application.documents
    end

    test "saves new application", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))

      assert index_live |> element("a", "New Application") |> render_click() =~
               "New Application"

      assert_patch(index_live, Routes.application_index_path(conn, :new))

      assert index_live
             |> form("#application-form", application: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#application-form", application: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.application_index_path(conn, :index))

      assert html =~ "Application created successfully"
      assert html =~ "some documents"
    end

    test "updates application in listing", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      application = application_fixture()

      {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))

      assert index_live |> element("#application-#{application.id} a", "Edit") |> render_click() =~
               "Edit Application"

      assert_patch(index_live, Routes.application_index_path(conn, :edit, application))

      assert index_live
             |> form("#application-form", application: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#application-form", application: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.application_index_path(conn, :index))

      assert html =~ "Application updated successfully"
      assert html =~ "some updated documents"
    end

    test "deletes application in listing", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      application = application_fixture()

      {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))

      assert index_live |> element("#application-#{application.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#application-#{application.id}")
    end
  end

  describe "Show" do
    setup [:create_application]

    test "displays application", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      application = application_fixture()

      {:ok, _show_live, html} = live(conn, Routes.application_show_path(conn, :show, application))

      assert html =~ "Show Application"
      assert html =~ application.documents
    end

    test "updates application within modal", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      application = application_fixture()

      {:ok, show_live, _html} = live(conn, Routes.application_show_path(conn, :show, application))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Application"

      assert_patch(show_live, Routes.application_show_path(conn, :edit, application))

      assert show_live
             |> form("#application-form", application: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#application-form", application: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.application_show_path(conn, :show, application))

      assert html =~ "Application updated successfully"
      assert html =~ "some updated documents"
    end
  end
end
