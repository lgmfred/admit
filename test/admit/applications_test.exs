defmodule Admit.ApplicationsTest do
  use Admit.DataCase

  alias Admit.Applications
  alias Admit.Schools

  describe "applications" do
    alias Admit.Applications.Application

    import Admit.ApplicationsFixtures
    import Admit.AccountsFixtures
    import Admit.SchoolsFixtures
    import Admit.ClassesFixtures
    import Admit.StudentsFixtures
    import Admit.AdvertsFixtures

    @invalid_attrs %{documents: nil, status: nil}

    test "list_applications/0 returns all applications" do
      user = user_fixture()
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          user_id: user.id,
          advert_id: advert.id,
          school_id: school.id,
          student_id: student.id
        })

      assert Applications.list_applications() == [application]
    end

    test "get_application!/1 returns the application with given id" do
      user = user_fixture()
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          user_id: user.id,
          advert_id: advert.id,
          school_id: school.id,
          student_id: student.id
        })

      assert Applications.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates an application" do
      user = user_fixture()
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      valid_attrs = %{
        documents: ["/uploads/some_crazy_docs.png"],
        status: "some status",
        user_id: user.id,
        advert_id: advert.id,
        school_id: school.id,
        student_id: student.id
      }

      assert {:ok, %Application{} = application} = Applications.create_application(valid_attrs)
      assert application.documents == ["/uploads/some_crazy_docs.png"]
      assert application.status == "some status"
    end

    test "create_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_application(@invalid_attrs)
    end

    test "update_application/2 with valid data updates the application" do
      user = user_fixture()
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          user_id: user.id,
          advert_id: advert.id,
          school_id: school.id,
          student_id: student.id
        })

      update_attrs = %{
        documents: ["/uploads/some_updated_documents"],
        status: "review"
      }

      assert {:ok, %Application{} = application} =
               Applications.update_application(application, update_attrs)

      assert application.documents == ["/uploads/some_updated_documents"]
      assert application.status == "review"
    end

    test "update_application/2 with invalid data returns error changeset" do
      user = user_fixture()
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          user_id: user.id,
          advert_id: advert.id,
          school_id: school.id,
          student_id: student.id
        })

      assert {:error, %Ecto.Changeset{}} =
               Applications.update_application(application, @invalid_attrs)

      assert application == Applications.get_application!(application.id)
    end

    test "delete_application/1 deletes the application" do
      user = user_fixture()
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          user_id: user.id,
          advert_id: advert.id,
          school_id: school.id,
          student_id: student.id
        })

      assert {:ok, %Application{}} = Applications.delete_application(application)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_application!(application.id) end
    end

    test "change_application/1 returns a application changeset" do
      user = user_fixture()
      school = school_fixture()
      {:ok, school} = Schools.add_admin(school.id, user.email)
      class = class_fixture(%{school_id: school.id})
      student = student_fixture(%{user_id: user.id})
      advert = advert_fixture(%{school_id: school.id, class_id: class.id})

      application =
        application_fixture(%{
          user_id: user.id,
          advert_id: advert.id,
          school_id: school.id,
          student_id: student.id
        })

      assert %Ecto.Changeset{} = Applications.change_application(application)
    end
  end
end
