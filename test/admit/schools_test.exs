defmodule Admit.SchoolsTest do
  use Admit.DataCase

  alias Admit.Accounts
  alias Admit.Repo
  alias Admit.Schools

  describe "schools" do
    alias Admit.Schools.School

    import Admit.SchoolsFixtures
    import Admit.AccountsFixtures

    @valid_attrs %{
      address: "some address",
      email: "some email",
      level: "some level",
      name: "some name",
      telephone: "some telephone"
    }

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
      assert {:ok, %School{} = school} = Schools.create_school(@valid_attrs)
      assert school.address == "some address"
      assert school.email == "some email"
      assert school.level == "some level"
      assert school.name == "some name"
      assert school.telephone == "some telephone"
    end

    test "create_school/1 with school admin creates a school with associated admins" do
      user = user_fixture()
      assert {:ok, %School{} = school} = Schools.create_school(@valid_attrs, user)
      user = Accounts.get_user!(user.id)
      school = Repo.preload(school, [:admins])

      assert school.name == "some name"
      assert user.school_id == school.id
      assert school.admins == [user]
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

    test "add_admin/2 add new admin to school admins" do
      user1 = user_fixture()
      user2 = user_fixture()
      assert {:ok, %School{} = school} = Schools.create_school(@valid_attrs, user1)
      assert {:ok, %School{} = school} = Schools.add_admin(school.id, user2.email)

      user1 = Accounts.get_user!(user1.id) |> Repo.preload([:school])
      user2 = Accounts.get_user!(user2.id) |> Repo.preload([:school])

      assert user1.school.id == school.id
      assert user2.school.id == school.id
      ## !! Weird preload related bug was here!! Brook fixed it!
      admin_users = Repo.preload(school, [admins: [:school]], force: true).admins
      assert Enum.sort(admin_users) == [user2, user1]
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
