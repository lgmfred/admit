defmodule Admit.AdminsTest do
  use Admit.DataCase

  alias Admit.Admins

  describe "school_admins" do
    alias Admit.Admins.SchoolAdmin

    import Admit.AdminsFixtures
    import Admit.AccountsFixtures
    import Admit.SchoolsFixtures

    @invalid_attrs %{level: nil, role: nil}

    test "list_school_admins/0 returns all school_admins" do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)
      assert Admins.list_school_admins() == [school_admin]
    end

    test "get_school_admin!/1 returns the school_admin with given id" do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)
      assert Admins.get_school_admin!(school_admin.id) == school_admin
    end

    test "create_school_admin/1 with valid data creates a school_admin" do
      user = user_fixture()
      school = school_fixture()

      valid_attrs =
        %{level: 42, role: "some role"}
        |> Map.put(:user_id, user.id)
        |> Map.put(:school_id, school.id)

      assert {:ok, %SchoolAdmin{} = school_admin} = Admins.create_school_admin(valid_attrs)
      assert school_admin.level == 42
      assert school_admin.role == "some role"
    end

    test "create_school_admin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admins.create_school_admin(@invalid_attrs)
    end

    test "update_school_admin/2 with valid data updates the school_admin" do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)
      update_attrs = %{level: 43, role: "some updated role"}

      assert {:ok, %SchoolAdmin{} = school_admin} =
               Admins.update_school_admin(school_admin, update_attrs)

      assert school_admin.level == 43
      assert school_admin.role == "some updated role"
    end

    test "update_school_admin/2 with invalid data returns error changeset" do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)

      assert {:error, %Ecto.Changeset{}} =
               Admins.update_school_admin(school_admin, @invalid_attrs)

      assert school_admin == Admins.get_school_admin!(school_admin.id)
    end

    test "delete_school_admin/1 deletes the school_admin" do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)
      assert {:ok, %SchoolAdmin{}} = Admins.delete_school_admin(school_admin)
      assert_raise Ecto.NoResultsError, fn -> Admins.get_school_admin!(school_admin.id) end
    end

    test "change_school_admin/1 returns a school_admin changeset" do
      user = user_fixture()
      school = school_fixture()
      school_admin = school_admin_fixture(user_id: user.id, school_id: school.id)
      assert %Ecto.Changeset{} = Admins.change_school_admin(school_admin)
    end
  end
end
