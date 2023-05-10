defmodule AdmitWeb.ApplicationLiveTest do
  use AdmitWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Admit.Schools

  import Admit.ApplicationsFixtures
  import Admit.AccountsFixtures
  import Admit.SchoolsFixtures
  import Admit.ClassesFixtures
  import Admit.StudentsFixtures
  import Admit.AdvertsFixtures
  import Admit.AdvertsFixtures

  # @create_attrs %{
  #   documents: ["/uploads/some_documents"]
  # }
  # @update_attrs %{
  #   documents: ["/uploads/some_updated_documents"],
  #   status: "review"
  # }
  # @invalid_attrs %{
  #   status: nil,
  #   documents: nil
  # }

  describe "Index" do
    test "lists all applications", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      student = student_fixture(%{user_id: user.id})
      school = school_fixture()
      class = class_fixture(%{school_id: school.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          advert_id: advert.id,
          user_id: user.id,
          student_id: student.id,
          school_id: school.id,
          class_id: class.id
        })

      {:ok, _index_live, html} = live(conn, Routes.application_index_path(conn, :index))

      assert html =~ "Listing Applications"
      assert html =~ school.name
      assert html =~ application.status
      assert html =~ class.name
      assert html =~ student.name
    end

    # test "saves new application from advert show page", %{conn: conn} do
    #   user = user_fixture()
    #   conn = log_in_user(conn, user)
    #   student = student_fixture(%{user_id: user.id})
    #   school = school_fixture()
    #   class = class_fixture(%{school_id: school.id})
    #   advert = advert_fixture(%{school_id: school.id, class_id: class.id})

    #   {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))
    #   {:ok, index_live, html} = live(conn, Routes.advert_show_path(conn, :show, advert))

    #   assert index_live |> element("a", "Apply Now") |> render_click() =~ "New Application"

    #   assert_patch(index_live, Routes.application_index_path(conn, :new))

    #   assert index_live
    #          |> form("#application-form", application: @invalid_attrs)
    #          |> IO.inspect(label: "Rendered form invalid")
    #          |> render_change() =~ "can&#39;t be blank"

    #   {:ok, _, html} =
    #     index_live
    #     |> form("#application-form", application: @create_attrs)
    #     |> IO.inspect(label: "Rendered form create")
    #     |> render_submit()
    #     |> follow_redirect(conn, Routes.application_index_path(conn, :index))

    #   assert html =~ "Application created successfully"
    #   assert html =~ "some documents"
    # end

    test "updates application in listing", %{conn: _conn} do
      # user = user_fixture()
      # conn = log_in_user(conn, user)
      # school = school_fixture()
      # class = class_fixture(%{school_id: school.id})
      # student = student_fixture(%{user_id: user.id})
      # advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      # application =
      #   application_fixture(%{
      #     school_id: school.id,
      #     user_id: user.id,
      #     class_id: class.id,
      #     student_id: student.id,
      #     advert_id: advert.id
      #   })

      # {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))

      # assert index_live |> element("#application-#{application.id} a", "Edit") |> render_click() =~
      #          "Edit Application"

      # assert_patch(index_live, Routes.application_index_path(conn, :edit, application))

      # assert index_live
      #        |> form("#application-form", application: @invalid_attrs)
      #        |> IO.inspect()
      #        |> render_change() =~ "can&#39;t be blank"

      # {:ok, _, html} =
      #   index_live
      #   |> form("#application-form", application: @update_attrs)
      #   |> render_submit()
      #   |> follow_redirect(conn, Routes.application_index_path(conn, :index))

      # assert html =~ "Application updated successfully"
      # assert html =~ student.name
    end

    test "deletes application in listing", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          school_id: school.id,
          user_id: user.id,
          class_id: class.id,
          student_id: student.id,
          advert_id: advert.id
        })

      {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))

      assert index_live |> element("#application-#{application.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#application-#{application.id}")
    end
  end

  describe "Show" do
    test "displays application", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          school_id: school.id,
          user_id: user.id,
          class_id: class.id,
          student_id: student.id,
          advert_id: advert.id
        })

      {:ok, _show_live, html} = live(conn, Routes.application_show_path(conn, :show, application))

      assert html =~ "Show Application"
      assert html =~ "Document 1"
    end

    test "updates application within modal", %{conn: _conn} do
      # user = user_fixture()
      # conn = log_in_user(conn, user)
      # school = school_fixture()
      # {:ok, school} = Schools.add_admin(school.id, user.email)
      # class = class_fixture(%{school_id: school.id})
      # student = student_fixture(%{user_id: user.id})
      # advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      # application =
      #   application_fixture(%{
      #     user_id: user.id,
      #     advert_id: advert.id,
      #     school_id: school.id,
      #     student_id: student.id
      #   })

      # {:ok, show_live, _html} = live(conn, Routes.application_show_path(conn, :show, application))

      # assert show_live |> element("a", "Edit") |> render_click() =~
      #          "Edit Application"

      # assert_patch(show_live, Routes.application_show_path(conn, :edit, application))

      # assert show_live
      #        |> form("#application-form", application: @invalid_attrs)
      #        |> render_change() =~ "can&#39;t be blank"

      # {:ok, _, html} =
      #   show_live
      #   |> form("#application-form", application: @update_attrs)
      #   |> render_submit()
      #   |> follow_redirect(conn, Routes.application_show_path(conn, :show, application))

      # assert html =~ "Application updated successfully"
      # assert html =~ "Document 1"
    end
  end
end
