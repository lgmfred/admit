defmodule Admit.ApplicationsTest do
  use Admit.DataCase

  alias Admit.Applications

  describe "applications" do
    alias Admit.Applications.Application

    import Admit.ApplicationsFixtures

    @invalid_attrs %{documents: nil, status: nil, submitted_on: nil}

    test "list_applications/0 returns all applications" do
      application = application_fixture()
      assert Applications.list_applications() == [application]
    end

    test "get_application!/1 returns the application with given id" do
      application = application_fixture()
      assert Applications.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates a application" do
      valid_attrs = %{
        documents: "some documents",
        status: "some status",
        submitted_on: ~N[2023-04-23 21:32:00]
      }

      assert {:ok, %Application{} = application} = Applications.create_application(valid_attrs)
      assert application.documents == "some documents"
      assert application.status == "some status"
      assert application.submitted_on == ~N[2023-04-23 21:32:00]
    end

    test "create_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_application(@invalid_attrs)
    end

    test "update_application/2 with valid data updates the application" do
      application = application_fixture()

      update_attrs = %{
        documents: "some updated documents",
        status: "some updated status",
        submitted_on: ~N[2023-04-24 21:32:00]
      }

      assert {:ok, %Application{} = application} =
               Applications.update_application(application, update_attrs)

      assert application.documents == "some updated documents"
      assert application.status == "some updated status"
      assert application.submitted_on == ~N[2023-04-24 21:32:00]
    end

    test "update_application/2 with invalid data returns error changeset" do
      application = application_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Applications.update_application(application, @invalid_attrs)

      assert application == Applications.get_application!(application.id)
    end

    test "delete_application/1 deletes the application" do
      application = application_fixture()
      assert {:ok, %Application{}} = Applications.delete_application(application)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_application!(application.id) end
    end

    test "change_application/1 returns a application changeset" do
      application = application_fixture()
      assert %Ecto.Changeset{} = Applications.change_application(application)
    end
  end
end
