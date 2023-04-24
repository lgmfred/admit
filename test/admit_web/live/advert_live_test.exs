defmodule AdmitWeb.AdvertLiveTest do
  use AdmitWeb.ConnCase

  import Phoenix.LiveViewTest
  import Admit.AdvertsFixtures
  import Admit.AccountsFixtures
  import Admit.ClassesFixtures
  import Admit.SchoolsFixtures

  @create_attrs %{
    deadline: Date.to_string(Date.add(Date.utc_today(), Enum.random(10..40))),
    description: "some description",
    published_on: Date.to_string(Date.utc_today())
  }
  @update_attrs %{
    deadline: Date.to_string(Date.add(Date.utc_today(), Enum.random(10..40))),
    description: "some updated description",
    published_on: Date.to_string(Date.utc_today())
  }
  @invalid_attrs %{
    deadline: Date.to_string(Date.add(Date.utc_today(), Enum.random(10..40))),
    description: nil,
    published_on: Date.to_string(Date.utc_today())
  }

  describe "Index" do
    test "lists all adverts", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      school = school_fixture()
      {:ok, school} = Admit.Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})
      {:ok, _index_live, html} = live(conn, Routes.advert_index_path(conn, :index))

      assert html =~ "Listing Adverts"
      assert html =~ advert.description
    end

    test "saves new advert", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      school = school_fixture()
      {:ok, school} = Admit.Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})

      create_attrs =
        @create_attrs
        |> Map.put(:class_id, class.id)

      {:ok, index_live, _html} = live(conn, Routes.advert_index_path(conn, :index))

      assert index_live |> element("a", "New Advert") |> render_click() =~
               "New Advert"

      assert_patch(index_live, Routes.advert_index_path(conn, :new))

      assert index_live
             |> form("#advert-form", advert: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#advert-form", advert: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.advert_index_path(conn, :index))

      assert html =~ "Advert created successfully"
      assert html =~ "some description"
    end

    test "updates advert in listing", %{conn: conn} do
      user = user_fixture()
      school = school_fixture()
      {:ok, school} = Admit.Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})

      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      conn = log_in_user(conn, user)

      {:ok, index_live, _html} = live(conn, Routes.advert_index_path(conn, :index))

      assert index_live |> element("#advert-#{advert.id} a", "Edit") |> render_click() =~
               "Edit Advert"

      assert_patch(index_live, Routes.advert_index_path(conn, :edit, advert))

      assert index_live
             |> form("#advert-form", advert: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#advert-form", advert: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.advert_index_path(conn, :index))

      assert html =~ "Advert updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes advert in listing", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      school = school_fixture()
      {:ok, school} = Admit.Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})

      advert =
        advert_fixture(%{school_id: school.id, class_id: class.id})
        |> Admit.Repo.preload([:school, :class])

      {:ok, index_live, _html} = live(conn, Routes.advert_index_path(conn, :index))

      assert index_live |> element("#advert-#{advert.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#advert-#{advert.id}")
    end
  end

  describe "Show" do
    test "displays advert", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      school = school_fixture()
      {:ok, school} = Admit.Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      {:ok, _show_live, html} = live(conn, Routes.advert_show_path(conn, :show, advert))

      assert html =~ "Show Advert"
      assert html =~ advert.description
    end

    test "updates advert within modal", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      school = school_fixture()
      {:ok, school} = Admit.Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      {:ok, show_live, _html} = live(conn, Routes.advert_show_path(conn, :show, advert))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Advert"

      assert_patch(show_live, Routes.advert_show_path(conn, :edit, advert))

      assert show_live
             |> form("#advert-form", advert: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#advert-form", advert: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.advert_show_path(conn, :show, advert))

      assert html =~ "Advert updated successfully"
      assert html =~ "some updated description"
    end
  end
end
