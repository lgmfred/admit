defmodule Admit.SchoolsTest do
  use Admit.DataCase

  alias Admit.Schools

  describe "schools" do
    alias Admit.Schools.School

    import Admit.SchoolsFixtures

    @invalid_attrs %{
      address: nil,
      email: nil,
      level: nil,
      name: nil,
      telephone: nil
    }

    test "list_schools/0 returns all schools" do
      school = school_fixture()
      assert Schools.list_schools() == [school]
    end

    test "get_school!/1 returns the school with given id" do
      school = school_fixture()
      assert Schools.get_school!(school.id) == school
    end

    test "create_school/1 with valid data creates a school" do
      valid_attrs = %{
        address: "some address",
        email: "some email",
        level: "some level",
        name: "some name",
        telephone: "some telephone"
      }

      assert {:ok, %School{} = school} = Schools.create_school(valid_attrs)
      assert school.address == "some address"
      assert school.email == "some email"
      assert school.level == "some level"
      assert school.name == "some name"
      assert school.telephone == "some telephone"
    end

    test "create_school/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schools.create_school(@invalid_attrs)
    end

    test "update_school/2 with valid data updates the school" do
      school = school_fixture()

      update_attrs = %{
        address: "some updated address",
        email: "some updated email",
        level: "some updated level",
        name: "some updated name",
        telephone: "some updated telephone"
      }

      assert {:ok, %School{} = school} = Schools.update_school(school, update_attrs)
      assert school.address == "some updated address"
      assert school.email == "some updated email"
      assert school.level == "some updated level"
      assert school.name == "some updated name"
      assert school.telephone == "some updated telephone"
    end

    test "update_school/2 with invalid data returns error changeset" do
      school = school_fixture()
      assert {:error, %Ecto.Changeset{}} = Schools.update_school(school, @invalid_attrs)
      assert school == Schools.get_school!(school.id)
    end

    test "delete_school/1 deletes the school" do
      school = school_fixture()
      assert {:ok, %School{}} = Schools.delete_school(school)
      assert_raise Ecto.NoResultsError, fn -> Schools.get_school!(school.id) end
    end

    test "change_school/1 returns a school changeset" do
      school = school_fixture()
      assert %Ecto.Changeset{} = Schools.change_school(school)
    end
  end
end
